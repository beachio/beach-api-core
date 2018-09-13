module BeachApiCore
  class WebhooksNotifier
    include ::Sidekiq::Worker
    sidekiq_options queue: 'webhooks'
    sidekiq_options retry: 10

    def perform(kind, model_class_name, model_id, doorkeeper_token_id = nil, parametrs = nil)
      if kind == 'scores_achieved'
        user = BeachApiCore::User.find(model_id)
        webhooks = Webhook.where(kind: Webhook.kinds[kind], :parametrs => "{\"scores\": #{parametrs.nil? ? user.scores : parametrs}}")
      else
        webhooks = Webhook.where(kind: Webhook.kinds[kind])
      end
      webhooks.find_each do |webhook|
        next if webhook.keeper_type != 'BeachApiCore::Instance' && webhook.keeper_id != doorkeeper_token(doorkeeper_token_id).application_id
        model = kind == 'organisation_deleted' ? BeachApiCore::Organisation.new(JSON.parse(parametrs)) : model_class_name.constantize.find(model_id)
        serialized_model = "BeachApiCore::#{model_class_name.demodulize}Serializer".constantize.new(model)
        send_notification(webhook.uri, kind, serialized_model, doorkeeper_token(doorkeeper_token_id))
      end
    end

    private

    def send_notification(uri, kind, serialized_model, doorkeeper_token)
      RestClient.post uri, { event: kind, model: serialized_model }.to_json, headers(doorkeeper_token)
    end

    def headers(doorkeeper_token)
      { 'X-USER-ID'         => doorkeeper_token.user.id,
        'Authorization'     => "Bearer #{doorkeeper_token.token}",
        'Content-type'      => 'application/json' }
    end

    def doorkeeper_token(doorkeeper_token_id)
      Doorkeeper::AccessToken.find(doorkeeper_token_id)
    end

  end
end
