class BeachApiCore::WebhookConfigUpdate
  include Interactor

  def call
    context.params.delete(:webhook_parameters)
    i = 0
    unless context.webhook_parameters.blank?
      attrs = {}
    end
    context.webhook_parameters.each do |parameter|
      attrs[i] = parameter.to_h
      i += 1
    end
    context.params[:webhook_parametrs_attributes] = attrs
    context.webhook_config.assign_attributes context.params
    if context.webhook_config.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.webhook_config.errors.full_messages
    end
  end
end