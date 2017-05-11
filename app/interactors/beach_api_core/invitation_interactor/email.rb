module BeachApiCore::InvitationInteractor
  class Email
    include Interactor

    def call
      if context.invitation.group.is_a?(BeachApiCore::Team) || context.invitation.group.is_a?(BeachApiCore::Organisation)
        BeachApiCore::InvitationMailer.group_invite(context.invitation).deliver_later
      end
    end
  end
end
