class BeachApiCore::EmailCreate
  include Interactor

  def call
    if context.scheduled_time
      BeachApiCore::ScheduledEmailSender.perform_at(
        context.scheduled_time, context.params
      )
    else
      BeachApiCore::ScheduledEmailSender.perform(context.params)
    end

    context.status = :created
  end
end
