class BeachApiCore::OrganisationDelete
  include Interactor::Organizer

  organize [BeachApiCore::OrganisationInteractor::Delete, BeachApiCore::WebhookInteractor::Notify]
end
