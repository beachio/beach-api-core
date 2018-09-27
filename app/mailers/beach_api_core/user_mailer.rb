module BeachApiCore
  class UserMailer < ApplicationMailer
    def register_confirm(application, user)
      get_variables(application, user, 1)
      mail from: from(:noreply_from), to: @user.email,
           subject: 'Please confirm your account'
    end

    def forgot_password(application, user)
      get_variables(application, user, 2)
      @greetings_text.gsub!("[RESET_TOKEN]", "<b>#{@user.reset_password_token}</b>") unless @greetings_text.nil?
      @signature_text.gsub!("[RESET_TOKEN]", "<b>#{@user.reset_password_token}</b>") unless @signature_text.nil?
      @footer_text.gsub!("[RESET_TOKEN]", "<b>#{@user.reset_password_token}</b>") unless @footer_text.nil?
      @body_text.gsub!("[RESET_TOKEN]", "<b>#{@user.reset_password_token}</b>") unless @body_text.nil?
      mail from: from(:noreply_from), to: @user.email,
           subject: 'Forgotten password request'
    end

    def get_variables(application, user, type)
      @application = application
      @user = user
      @mail_config = @application.mail_bodies.where(:mail_type => type).first
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
