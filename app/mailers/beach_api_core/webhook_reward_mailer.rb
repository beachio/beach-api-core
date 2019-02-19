module BeachApiCore
  class WebhookRewardMailer < ApplicationMailer
    def reward_achieved(application, user)
      get_variables(application, user)
      mail from: from(:noreply_from), to: @user.email,
           subject: 'Webhook Reward achieved'
    end

    def get_variables(application, user)
      @application = application
      @user = user
      @mail_config = @application.mail_bodies.where(:mail_type => 3).first
      @greetings_text = @mail_config.greetings_text.gsub("[USER_NAME]", @user.display_name )
                            .gsub("[APPLICATION_NAME]", @application.name) unless @mail_config.nil? || @mail_config.greetings_text.nil? || @mail_config.greetings_text.empty?
      @signature_text = @mail_config.signature_text.gsub("[USER_NAME]", @user.display_name )
                            .gsub("[APPLICATION_NAME]", @application.name) unless @mail_config.nil? || @mail_config.signature_text.nil? || @mail_config.signature_text.empty?
      @footer_text = @mail_config.footer_text.gsub("[USER_NAME]", @user.display_name )
                         .gsub("[APPLICATION_NAME]", @application.name) unless @mail_config.nil? || @mail_config.footer_text.nil? || @mail_config.footer_text.empty?
      @body_text = @mail_config.body_text.gsub("[USER_NAME]", @user.display_name )
                       .gsub("[APPLICATION_NAME]", @application.name) unless @mail_config.nil? || @mail_config.body_text.nil? || @mail_config.body_text.empty?

      @button_text = @mail_config.button_text.gsub("[USER_NAME]", @user.display_name )
                         .gsub("[APPLICATION_NAME]", @application.name) unless @mail_config.nil? || @mail_config.button_text.nil? || @mail_config.button_text.empty?
    end
  end
end