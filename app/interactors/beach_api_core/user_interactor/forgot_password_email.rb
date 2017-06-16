module BeachApiCore::UserInteractor
  class ForgotPasswordEmail
    include Interactor

    def call
      BeachApiCore::UserMailer.forgot_password(context.application, context.user).deliver_later
    end
  end
end
