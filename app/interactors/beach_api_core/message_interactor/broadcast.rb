module BeachApiCore::MessageInteractor
  class Broadcast
    include Interactor

    def call
      context.chat.users.each do |user|
        BeachApiCore::UserChannel.broadcast_to(user, user: user, payload: { message: context.message.message })
      end
      context.status = :ok
    end
  end
end
