module BeachApiCore
  class MailBodyUpdate
    include Interactor

    def call
      if context.mail_body.update context.params
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.mail_body.errors.full_messages
      end
    end
  end
end
