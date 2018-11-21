class BeachApiCore::ApplicationChannel < ApplicationCable::Channel
  def subscribed
    app = Doorkeeper::Application.find_by(uid: params[:uid])
    stream_for app
  end
end
