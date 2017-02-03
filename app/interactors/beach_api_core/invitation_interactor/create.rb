module BeachApiCore::InvitationInteractor
  class Create
    include Interactor

    def call
      context.invitation = context.group.invitations.build context.params
      context.invitation.assign_attributes(user: context.user)

      if context.invitation.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.invitation.errors.full_messages
      end
    end
  end
end
