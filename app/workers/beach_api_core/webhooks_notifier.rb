module BeachApiCore
  class WebhooksNotifier
    include ::Sidekiq::Worker
    sidekiq_options queue: 'webhooks'
    sidekiq_options retry: 10

    def perform(kind)
      Webhook.where(kind: Webhook.kinds[kind]).find_each do |webhook|
        send_notification(webhook.uri, kind)
      end
    end

    private

    def send_notification(uri, kind)
      client = RestClient::Resource.new uri
      client.post(event: kind)
    end
  end
end
