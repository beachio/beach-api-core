class BeachApiCore::ServiceUpdate
  include Interactor

  def call
    if context.service.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.service.errors.full_messages
    end
  end
end
