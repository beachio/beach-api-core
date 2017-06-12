class BeachApiCore::ChatAddRecipient
  include Interactor

  def call
    context.chat.chats_users.build(user: context.recipient)

    if context.chat.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.chat.errors.full_messages
    end
  end
end
