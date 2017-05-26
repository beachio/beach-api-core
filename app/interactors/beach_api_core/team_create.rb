class BeachApiCore::TeamCreate
  include Interactor::Organizer

  organize [
               BeachApiCore::WebhookInteractor::TeamCreate,
               BeachApiCore::WebhookInteractor::Notify
           ]
end
