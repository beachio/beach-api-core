class BeachApiCore::InvitationAccept
  include Interactor::Organizer

  organize [BeachApiCore::InvitationInteractor::Accept,
            BeachApiCore::UserInteractor::Email,
            BeachApiCore::Authorization::CreateAccessToken]
end
