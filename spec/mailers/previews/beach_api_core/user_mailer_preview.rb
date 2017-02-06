module BeachApiCore
  # Preview all emails at http://localhost:3000/rails/mailers/user_mailer
  class UserMailerPreview < ActionMailer::Preview
    def register_confirm
      UserMailer.register_confirm(User.first)
    end
  end
end
