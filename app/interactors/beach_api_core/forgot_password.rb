class BeachApiCore::ForgotPassword
  include Interactor::Organizer

  organize [BeachApiCore::UserInteractor::CreateResetToken,
            BeachApiCore::UserInteractor::ForgotPasswordEmail]
end
