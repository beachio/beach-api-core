module BeachApiCore::WebhookInteractor
  class OrganisationCreate
    include Interactor

    def call
      context.organisation = BeachApiCore::Organisation.new context.params
      context.organisation.assign_attributes(application: context.application)
      context.organisation.memberships.build member: context.user, owner: true
      if context.organisation.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.organisation.errors.full_messages
      end
    end
  end
end
