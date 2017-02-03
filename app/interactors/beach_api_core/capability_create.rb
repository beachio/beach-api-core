class BeachApiCore::CapabilityCreate
  include Interactor

  def call
    context.capability = context.service.capabilities.build(application: context.application)

    if context.capability.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.capability.errors.full_messages
    end
  end
end
