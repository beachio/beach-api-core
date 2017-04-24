module BeachApiCore
  class ScheduledEmailSender
    include ::Sidekiq::Worker
    sidekiq_options queue: 'email'
    sidekiq_options retry: 10

    def perform(opts = {})
      ServiceMailer.send!(opts).deliver
    end
  end
end
