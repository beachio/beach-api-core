module ChannelsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/channels', I18n.t('api.resource_description.descriptions.channels.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :entity, Hash do
    param :uid, String, required: true
    param :kind, String, required: true
  end
  example "\"channels\": [#{apipie_user_channel_response}, #{apipie_entity_channel_response}]"
  def index_doc; end
end
