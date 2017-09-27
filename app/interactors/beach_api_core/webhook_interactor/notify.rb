module BeachApiCore::WebhookInteractor
  class Notify
    include Interactor

    def call
      kind = BeachApiCore::Webhook.class_to_kind(context.model.class, context.event)
      return unless kind
      BeachApiCore::Webhook.notify(kind, context.model.class.name, context.model.id, context.access_token.id)
    end
  end
end
