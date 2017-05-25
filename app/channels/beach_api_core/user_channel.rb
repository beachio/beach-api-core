class BeachApiCore::UserChannel < ApplicationCable::Channel
  def subscribed
    user = BeachApiCore::User.find(params[:id])
    # @todo: implement current user for ApplicationCable::Connection
    # ::Pundit.policy(current_user, user).show?
    stream_for user
  end
end
