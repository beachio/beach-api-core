module MessagesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/chats/:id/messages', I18n.t('api.resource_description.descriptions.messages.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"messages\": [#{apipie_message_response}, ...]"
  def index_doc; end

  api :POST, '/chats/:id/messages', I18n.t('api.resource_description.descriptions.messages.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :message, String, required: true
  example "\"message\": #{apipie_message_response}
    \n#{I18n.t('api.resource_description.fail',
               description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create_doc; end
end
