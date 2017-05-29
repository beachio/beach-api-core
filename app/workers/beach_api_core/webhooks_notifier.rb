module BeachApiCore
  class WebhooksNotifier
    include ::Sidekiq::Worker
    sidekiq_options queue: 'webhooks'
    sidekiq_options retry: 10

    def perform(kind, model_class_name, model_id)
      Webhook.where(kind: Webhook.kinds[kind]).find_each do |webhook|
        model = model_class_name.constantize.find(model_id)
        serialized_model = "BeachApiCore::#{model_class_name.demodulize}Serializer".constantize.new(model).to_json
        send_notification(webhook.uri, kind, serialized_model)
      end
    end

    private

    def send_notification(uri, kind, serialized_model)
      RestClient.post uri, { event: kind, model: serialized_model }.to_json, content_type: :json
    end
  end
end
