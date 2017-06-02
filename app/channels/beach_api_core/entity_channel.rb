class BeachApiCore::EntityChannel < ApplicationCable::Channel
  def subscribed
    entity = BeachApiCore::Entity.find(params[:id])
    # @todo: implement current user for ApplicationCable::Connection
    # ::Pundit.policy(current_user, invention).show?
    stream_for entity
  end
end
