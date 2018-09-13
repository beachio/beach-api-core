class BeachApiCore::WebhookCreate
  include Interactor

  def call
    context.webhook = BeachApiCore::Webhook.new(uri: context.uri, keeper: context.keeper, kind: context.kind, :scores => context.scores.nil? ? "{}" : context.scores)
    if context.webhook.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.webhook.errors.full_messages
    end
  end
end
