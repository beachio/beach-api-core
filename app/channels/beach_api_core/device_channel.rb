class BeachApiCore::DeviceChannel < ApplicationCable::Channel
  def subscribed
    device = BeachApiCore::Device.find(params[:device_id])
    stream_for device
  end

end