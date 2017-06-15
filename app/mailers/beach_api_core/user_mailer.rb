module BeachApiCore
  class UserMailer < ApplicationMailer
    def register_confirm(application, user)
      @application = application
      @user = user
      mail from: from(:noreply_from), to: @user.email,
           subject: 'Please confirm your account'
    end

    def forgot_password(application, user)
      @application = application
      @user = user
      mail from: from(:noreply_from), to: @user.email,
           subject: 'Forgotten password request'
    end
  end
end
