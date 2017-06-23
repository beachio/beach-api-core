module WebhooksDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/webhooks', I18n.t('api.resource_description.descriptions.webhooks.list')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"webhooks\": [#{apipie_webhook_response}, ...]"
  def index; end

  api :POST, '/webhooks', I18n.t('api.resource_description.descriptions.webhooks.create')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  param :webhook, Hash, required: true do
    param :uri, String, required: true
    param :kind, String, required: true, desc: I18n.t('api.resource_description.descriptions.params.event_type')
  end
  example "\"webhook\": #{apipie_webhook_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :DELETE, '/webhooks/:id', I18n.t('api.resource_description.descriptions.webhooks.remove')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/webhook.downcase')))
  def destroy; end
end
