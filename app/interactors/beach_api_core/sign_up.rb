class BeachApiCore::SignUp
  include Interactor::Organizer

  organize [
               BeachApiCore::UserInteractor::AuthenticateApplication,
               BeachApiCore::UserInteractor::Create,
               BeachApiCore::UserInteractor::Email,
               BeachApiCore::UserInteractor::CreateAccessToken
           ]

end
