module BeachApiCore::InvitationInteractor
  class Email
    include Interactor

    def call
      if context.invitation.group.is_a?(Team) || context.invitation.group.is_a?(Organisation)
        BeachApiCore::InvitationMailer.group_invite(context.invitation).deliver_now
      end
    end
  end
end
