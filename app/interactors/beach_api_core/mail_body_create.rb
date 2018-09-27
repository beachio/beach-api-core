module BeachApiCore
  class MailBodyCreate
    include Interactor

    def call
      context.mail_body = BeachApiCore::MailBody.new(context.params)
      context.mail_body.application = context.application
      if context.mail_body.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.mail_body.errors.full_messages
      end
    end
  end
end
