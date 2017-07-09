module EntityMessagesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/entities/:id/messages', I18n.t('api.resource_description.descriptions.entity_messages.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"interactions\": [#{apipie_message_interaction_response}, ...]"
  def index; end

  api :POST, '/entities/:id/messages', I18n.t('api.resource_description.descriptions.entity_messages.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"interaction\": #{apipie_message_interaction_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  param :message, Hash, required: true do
    param :text, String
  end
  def create; end

  api :PUT, '/entities/:id/messages', I18n.t('api.resource_description.descriptions.entity_messages.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"interaction\": #{apipie_message_interaction_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  param :message, Hash, required: true do
    param :text, String
  end
  def update; end

  api :DELETE, '/entities/:id/messages/:id', I18n.t('api.resource_description.descriptions.entity_messages.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove_this',
                                     model: I18n.t('activerecord.models.entity_message.downcase')))
  def destroy; end
end
