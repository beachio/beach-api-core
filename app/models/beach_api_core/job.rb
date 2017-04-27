module BeachApiCore
  class Job < ApplicationRecord
    validates :start_at, presence: true
    validate :required_params_present

    after_create :schedule_job

    # @todo: move custom setters to concern
    def params=(value)
      value[:input] ||= {}
      value[:input] = value[:input].to_json unless value[:input].is_a?(String)
      write_attribute(:params, value)
    end

    def result=(value)
      value[:body] ||= {}
      value[:body] = value[:body].to_json unless value[:body].is_a?(String)
      write_attribute(:result, value)
    end

    private

    def required_params_present
      keys = params.symbolize_keys.keys
      return if ([:bearer, :method, :uri] - keys).empty?
      errors.add(:params, 'must include bearer, method and uri')
    end

    def schedule_job
      JobRunner.perform_at(start_at, id)
    end
  end
end
