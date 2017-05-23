module AssignmentsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/assignments', I18n.t('api.resource_description.descriptions.assignments.assign')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :assignment, Hash, required: true do
    param :role_id, Integer, required: true
    param :user_id, Integer, required: true
  end
  example "\"assignment\": #{apipie_assignment_response}"
  def create; end

  api :DELETE, '/assignments/:id', I18n.t('api.resource_description.descriptions.assignments.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail', description: I18n.t('api.errors.could_not_remove',
                                                                      model: I18n.t('activerecord.models.beach_api_core/role.downcase')))
  def destroy; end
end
