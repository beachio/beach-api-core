module BeachApiCore
  class InvitationMailer < ApplicationMailer
    def group_invite(invitation, application)
      @invitation = invitation
      @user = invitation.user
      @group_name = invitation.group.name
      @app_name = app_name(invitation)
      @organisation = organisation(invitation)
      @application = application
      @mail_config = @application.mail_bodies.where(:mail_type => 0).first

      @greetings_text = @mail_config.greetings_text.gsub("[INVITEE_NAME]", @invitation.invitee.display_name )
                            .gsub("[APPLICATION_NAME]", @application.name)
                            .gsub("[GROUP_NAME]", @group_name)
                            .gsub("[INVITATION_FROM_USER]", @invitation.user.display_name) unless @mail_config.nil? || @mail_config.greetings_text.nil? || @mail_config.greetings_text.empty?
      @signature_text = @mail_config.signature_text.gsub("[INVITEE_NAME]", @invitation.invitee.display_name )
                            .gsub("[APPLICATION_NAME]", @application.name)
                            .gsub("[GROUP_NAME]", @group_name)
                            .gsub("[INVITATION_FROM_USER]", @invitation.user.display_name) unless @mail_config.nil? || @mail_config.signature_text.nil? || @mail_config.signature_text.empty?
      @footer_text = @mail_config.footer_text.gsub("[INVITEE_NAME]", @invitation.invitee.display_name )
                         .gsub("[APPLICATION_NAME]", @application.name)
                         .gsub("[GROUP_NAME]", @group_name)
                         .gsub("[INVITATION_FROM_USER]", @invitation.user.display_name) unless @mail_config.nil? || @mail_config.footer_text.nil? || @mail_config.footer_text.empty?
      @body_text = @mail_config.body_text.gsub("[INVITEE_NAME]", @invitation.invitee.display_name )
                       .gsub("[APPLICATION_NAME]", @application.name)
                       .gsub("[GROUP_NAME]", @group_name)
                       .gsub("[INVITATION_FROM_USER]", @invitation.user.display_name) unless @mail_config.nil? || @mail_config.body_text.nil? || @mail_config.body_text.empty?

      @button_text = @mail_config.button_text.gsub("[INVITEE_NAME]", @invitation.invitee.display_name )
                         .gsub("[APPLICATION_NAME]", @application.name)
                         .gsub("[GROUP_NAME]", @group_name)
                         .gsub("[INVITATION_FROM_USER]", @invitation.user.display_name) unless @mail_config.nil? || @mail_config.button_text.nil? || @mail_config.button_text.empty?
      mail(from: from(:noreply_from), to: @invitation.email,
           subject: "Invitation to join a #{app_name(invitation)} team")
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
      return invitation.group if invitation.group.is_a?(BeachApiCore::Organisation)
      return unless invitation.group.respond_to?(:organisation)
      invitation.group.organisation
    end
  end
end
