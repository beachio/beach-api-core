module BeachApiCore
  # Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
  class InvitationMailerPreview < ActionMailer::Preview
    def group_invite
      InvitationMailer.group_invite(Invitation.first)
    end
  end
end
