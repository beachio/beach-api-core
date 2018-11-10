class BeachApiCore::DeviceDestroy
  include Interactor

  def call
    if context.device.destroy
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.device.errors.full_messages
    end
  end
end
