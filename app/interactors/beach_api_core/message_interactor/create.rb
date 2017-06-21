module BeachApiCore::MessageInteractor
  class Create
    include Interactor

    def call
      context.message = context.chat.messages.build(context.params)
      context.message.assign_attributes(sender: context.current_user)
      context.chat.users.each { |user| context.message.messages_users.build(user: user) }

      if context.message.save
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.message.errors.full_messages
      end
    end
  end
end
