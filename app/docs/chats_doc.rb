module ChatsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/chats', I18n.t('api.resource_description.descriptions.chats.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"chats\": [#{apipie_chat_response}, ...]"
  def show; end

  api :POST, '/chats', I18n.t('api.resource_description.descriptions.chats.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :chat, Hash, required: true do
    param :chats_users_attributes, Array, required: true do
      param :user_id, Integer, required: true
    end
  end
  example "\"chat\": #{apipie_chat_response}
    \n#{I18n.t('api.resource_description.fail',
               description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :POST, '/chats/:id/add_recipient', I18n.t('api.resource_description.descriptions.chats.add_recipient')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :chat, Hash, required: true do
    param :recipient_id, Integer, required: true
  end
  example "\"chat\": #{apipie_chat_response}
    \n#{I18n.t('api.resource_description.fail',
               description: I18n.t('api.resource_description.fails.errors_description'))}"
  def add_recipient; end

  api :POST, '/chats/:id/read', I18n.t('api.resource_description.descriptions.chats.read')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :chat, Hash, required: true do
    param :recipient_id, Integer, required: true
  end
  example "\"chat\": #{apipie_chat_response}
    \n#{I18n.t('api.resource_description.fail',
               description: I18n.t('api.resource_description.fails.errors_description'))}"
  def read; end
end
