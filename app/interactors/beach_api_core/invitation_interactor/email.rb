module BeachApiCore::InvitationInteractor
  class Email
    include Interactor

    def call
      return unless [BeachApiCore::Team, BeachApiCore::Organisation].include?(context.invitation.group.class)
      BeachApiCore::InvitationMailer.group_invite(context.invitation, context.application).deliver_later
    end
  end
end
