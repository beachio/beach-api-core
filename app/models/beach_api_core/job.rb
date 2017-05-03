module BeachApiCore
  class Job < ApplicationRecord
    serialize :params, Hash
    serialize :result, Hash

    validates :every, format: { with: /\A\d+\.\w+\z/ }, allow_nil: true
    validate :schedule_present
    validate :required_params_present

    after_create :schedule_sidekiq_job, if: 'start_at.present? && every.blank?'

    class << self
      def perform_cron
        where.not(every: nil).find_each do |job|
          next unless job.last_run.nil? || job.last_run + eval(job.every) <= Time.now
          BeachApiCore::JobRunner.perform_async(job.id)
        end
      end
    end

    private

    def schedule_present
      return if start_at.present? || every.present?
      errors.add(:start_at, 'is required')
    end

    def required_params_present
      return if ([:bearer, :method, :uri] - params.symbolize_keys.keys).empty?
      errors.add(:params, 'must include bearer, method and uri')
    end

    def schedule_sidekiq_job
      JobRunner.perform_at(start_at, id)
    end
  end
end
