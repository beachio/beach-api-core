module BeachApiCore::WebhookInteractor
  class Notify
    include Interactor

    def call
      return unless context.success?
      kind = BeachApiCore::Webhook.class_to_kind(context.model.class)
      BeachApiCore::Webhook.notify(kind, context.model.class.name, context.model.id, context.access_token.id)
    end
  end
end
