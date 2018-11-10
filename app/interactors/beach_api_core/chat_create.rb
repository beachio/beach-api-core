class BeachApiCore::ChatCreate
  include Interactor

  def call
    context.chat = BeachApiCore::Chat.new(context.params)
    context.chat.assign_attributes(keeper: context.keeper)
    if context.user && !context.chat.chats_users.map(&:user_id).include?(context.user.id)
      context.chat.chats_users.build(user: context.user)
    end

    if context.chat.save
      context.status = 201
    else
      context.status = :bad_request
      context.fail! message: context.chat.errors.full_messages
    end
  end
end
