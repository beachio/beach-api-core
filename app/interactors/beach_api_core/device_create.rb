class BeachApiCore::DeviceCreate
  include Interactor

  def call
    context.device = BeachApiCore::Device.new(context.params)
    puts "Context User:"
    puts context

    if context.user
      context.device.user = context.user

      if context.device.save
        context.status = 201
      else
        context.status = :bad_request
        context.fail! message: context.device.errors.full_messages
      end
    else
      context.status = 401
      context.fail! message: "Not authorized"
    end

  end
end
