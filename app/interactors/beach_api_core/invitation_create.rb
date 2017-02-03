class BeachApiCore::InvitationCreate
  include Interactor::Organizer

  organize [
               BeachApiCore::InvitationInteractor::Create,
               BeachApiCore::InvitationInteractor::Email
           ]

end
