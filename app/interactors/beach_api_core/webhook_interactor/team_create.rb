module BeachApiCore::WebhookInteractor
  class TeamCreate
    include Interactor

    before do
      context.team = context.model = BeachApiCore::Team.new(context.params) # create with alias
      context.event = 'created'
      context.team.assign_attributes(application: context.application)
      context.team.memberships.build member: context.user, owner: true
    end

    def call
      if context.team.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.team.errors.full_messages
      end
    end
  end
end
