module BeachApiCore
  class UserMailer < ApplicationMailer
    default from: 'noreply@example.com'

    def register_confirm(user)
      @user = user
      mail to: @user.email,
           subject: 'Please confirm your account'
    end
  end
end
