module EntitiesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/entities/:id', I18n.t('api.resource_description.descriptions.entities.show')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"entity\": #{apipie_entity_response}"
  def show; end

  api :POST, '/entities', I18n.t('api.resource_description.descriptions.entities.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :uid, String, required: true
  param :kind, String, required: true
  param :settings, Hash
  example "\"entity\": #{apipie_entity_response}
                  \n#{I18n.t('api.resource_description.fail',
                             description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :DELETE, '/entities/:id', I18n.t('api.resource_description.descriptions.entities.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/entity.downcase')))
  def destroy; end

  api :GET, '/entities/lookup', I18n.t('api.resource_description.descriptions.entities.lookup')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :uid, String, required: true
  param :kind, String, required: true
  example "\"entity\": #{apipie_entity_response}"
  def lookup; end
end
