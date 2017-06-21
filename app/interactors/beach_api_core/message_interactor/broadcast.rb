module BeachApiCore::MessageInteractor
  class Broadcast
    include Interactor

    def call
      BeachApiCore::UserChannel.broadcast_to(context.current_user, 'user' => context.current_user)
      context.status = :ok
    end
  end
end
