module BeachApiCore
  class BroadcastSend
    include Interactor

    before do
      context.user = User.find(context.params[:user_id])
    end

    def call
      UserChannel.broadcast_to(context.user, payload: context.params[:user_id])
      context.status = :created
    end
  end
end
