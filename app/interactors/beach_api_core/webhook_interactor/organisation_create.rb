module BeachApiCore::WebhookInteractor
  class OrganisationCreate
    include Interactor
    
    before do
      context.organisation = context.model = BeachApiCore::Organisation.new(context.params) # create with alias
      context.event = 'created'
      context.organisation.assign_attributes(application: context.application)
      context.organisation.memberships.build member: context.user, owner: true
    end

    def call
      if context.organisation.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.organisation.errors.full_messages
      end
    end
  end
end
