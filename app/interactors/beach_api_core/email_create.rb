module BeachApiCore
  class EmailCreate
    include Interactor

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
        body: context.email[:body],
        plain: context.email[:plain] }
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
