class BeachApiCore::SignUp
  include Interactor::Organizer

  organize [
               BeachApiCore::UserInteractor::AuthenticateApplication,
               BeachApiCore::UserInteractor::Create,
               BeachApiCore::UserInteractor::Email,
               BeachApiCore::Authorization::CreateAccessToken
           ]

end
