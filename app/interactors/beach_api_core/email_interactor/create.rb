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
        BeachApiCore::EmailSender.perform_at(
          context.scheduled_time || DateTime.now, email_params
        )

        context.status = :created
      end

      private

      def email_params
        { from: context.email[:from],
          to: recipients,
          cc: context.email[:cc],
          subject: context.email[:subject],
          body: context.email[:body] }
      end

      def recipients
        if context.email[:user_ids]
          User.where(id: context.email[:user_ids]).pluck(:email).join(',')
        else
          context.email[:to]
        end
      end
    end
  end
end
