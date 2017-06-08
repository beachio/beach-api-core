class BeachApiCore::ChatAddRecipient
  include Interactor

  def call
    context.chat.add_recipient(context.recipient)

    if context.chat.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.chat.errors.full_messages
    end
  end
end
