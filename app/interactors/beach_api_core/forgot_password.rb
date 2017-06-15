class BeachApiCore::ForgotPassword
  include Interactor::Organizer

  organize [BeachApiCore::UserInteractor::AuthenticateApplication,
            BeachApiCore::UserInteractor::CreateResetToken,
            BeachApiCore::UserInteractor::ForgotPasswordEmail]
end
