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
      params = {
        from: context.email[:from],
        to: recipients,
        cc: context.email[:cc],
        subject: context.email[:subject],
        body: context.email[:body],
        plain: context.email[:plain]
      }
      if context.email[:template]
        params[:template] = context.email[:template]
        params[:template_name] = context.email[:template_params] || {}
      end
      params
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
