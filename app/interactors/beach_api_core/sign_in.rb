class BeachApiCore::SignIn
  include Interactor::Organizer

  organize [BeachApiCore::UserInteractor::AuthenticateApplication,
            BeachApiCore::Authorization::AuthorizeUser,
            BeachApiCore::Authorization::CreateAccessToken]
end
