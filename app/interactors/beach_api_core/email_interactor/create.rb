module BeachApiCore
  module EmailInteractor
    class Create
      include Interactor

      before do
        unless context.application
          context.fail!(
            message: ['Application ID and/or secret are not correct'],
            status: :unauthorized
          )
        end
      end

      def call
        if context.scheduled_time
          BeachApiCore::ScheduledEmailSender.perform_at(
            context.scheduled_time, context.params
          )
        else
          BeachApiCore::ScheduledEmailSender.perform_async(context.params)
        end

        context.status = :created
      end
    end
  end
end
