class BeachApiCore::OrganisationCreate
  include Interactor::Organizer

  organize [
               BeachApiCore::WebhookInteractor::OrganisationCreate,
               BeachApiCore::WebhookInteractor::Notify
           ]
end
