class BeachApiCore::InvitationAccept
  include Interactor::Organizer

  organize [
             BeachApiCore::InvitationInteractor::Accept,
             BeachApiCore::Authorization::CreateAccessToken
           ]
end
