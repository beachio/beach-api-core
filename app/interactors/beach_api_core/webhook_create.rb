class BeachApiCore::WebhookCreate
  include Interactor

  def call
    context.webhook = context.application.webhooks.build(context.params)
    if context.webhook.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.webhook.errors.full_messages
    end
  end
end
