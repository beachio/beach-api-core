class BeachApiCore::ResetPassword
  include Interactor::Organizer

  organize [
             BeachApiCore::UserInteractor::CreateResetToken,
             BeachApiCore::UserInteractor::ForgotPasswordEmail
           ]
end
