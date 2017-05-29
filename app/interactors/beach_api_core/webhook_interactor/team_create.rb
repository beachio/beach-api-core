module BeachApiCore::WebhookInteractor
  class TeamCreate
    include Interactor

    def call
      context.team = BeachApiCore::Team.new context.params
      context.team.assign_attributes(application: context.application)
      context.team.memberships.build member: context.user, owner: true
      context.model = context.team # create alias

      if context.team.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.team.errors.full_messages
      end
    end
  end
end
