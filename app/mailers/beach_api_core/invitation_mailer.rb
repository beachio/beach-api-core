module BeachApiCore
  class InvitationMailer < ApplicationMailer
    default from: 'noreply@example.com'

    def group_invite(invitation)
      @invitation = invitation
      @user = invitation.user
      @group_name = invitation.group.name
      @app_name = app_name(invitation)
      @organisation = organisation(invitation)
      mail(to: @invitation.email, subject: "Invitation to join a #{app_name(invitation)} team")
    end

    private

    def app_name(invitation)
      if invitation.group.is_a?(Team) && invitation.group.organisation
        invitation.group.organisation.name
      else
        invitation.group.application.name
      end
    end

    def organisation(invitation)
      return invitation.group if invitation.group.is_a?(Organisation)
      return unless invitation.group.respond_to?(:organisation)
      invitation.group.organisation
    end
  end
end
