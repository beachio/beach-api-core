module UserAccessesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/user_accesses', I18n.t('api.resource_description.descriptions.user_accesses.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :user_access, Hash, required: true do
    param :user_id, Integer, required: true
    param :access_level_id, Integer, required: true
  end
  example "\"user_access\": #{apipie_assignment_response}"
  def create; end

  api :DELETE, '/user_accesses/:id', I18n.t('api.resource_description.descriptions.user_accesses.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/access_level.downcase')))
  def destroy; end
end
