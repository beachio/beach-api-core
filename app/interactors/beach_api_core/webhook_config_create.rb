class BeachApiCore::WebhookConfigCreate
  include Interactor

  def call
    context.params.delete(:webhook_parameters)
    context.webhook_config = BeachApiCore::WebhookConfig.new context.params
    context.webhook_config.application = context.application
    context.webhook_parameters.each do |parameter|
      context.webhook_config.webhook_parametrs.new parameter
    end unless context.webhook_parameters.blank?
    if context.webhook_config.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.webhook_config.errors.full_messages
    end
  end
end