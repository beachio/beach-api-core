class BeachApiCore::ResetPassword
  include Interactor::Organizer

  organize [BeachApiCore::UserInteractor::AuthenticateApplication,
            BeachApiCore::UserInteractor::ResetPassword]
end
