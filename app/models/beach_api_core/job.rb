module BeachApiCore
  class Job < ApplicationRecord
    validates :start_at, presence: true

    after_create :schedule_job

    private

    def schedule_job
      JobRunner.perform_at(start_at, id)
    end
  end
end
