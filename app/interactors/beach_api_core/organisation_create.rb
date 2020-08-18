class BeachApiCore::OrganisationCreate
  include Interactor::Organizer

  organize [
    BeachApiCore::WebhookInteractor::OrganisationCreate,
    BeachApiCore::NotificationInteractor::Create,
    BeachApiCore::WebhookInteractor::Notify
  ]
end
