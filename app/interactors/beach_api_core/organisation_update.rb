class BeachApiCore::OrganisationUpdate
  include Interactor

  def call
    if context.organisation.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.organisation.errors.full_messages
    end
  end
end
