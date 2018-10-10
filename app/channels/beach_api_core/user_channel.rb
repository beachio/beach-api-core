class BeachApiCore::UserChannel < ApplicationCable::Channel
  def subscribed
    user =  Doorkeeper::AccessToken.find_by_token(params[:token])
    # @todo: implement current user for ApplicationCable::Connection
    # ::Pundit.policy(current_user, user).show?
    stream_for user
  end
end
