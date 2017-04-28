module BeachApiCore
  class Job < ApplicationRecord
    serialize :params, Hash
    serialize :result, Hash

    validates :start_at, presence: true
    validate :required_params_present

    after_create :schedule_job

    private

    def required_params_present
      return if ([:bearer, :method, :uri] - params.symbolize_keys.keys).empty?
      errors.add(:params, 'must include bearer, method and uri')
    end

    def schedule_job
      JobRunner.perform_at(start_at, id)
    end
  end
end
