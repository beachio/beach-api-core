module EndpointsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/endpoints', I18n.t('api.resource_description.descriptions.endpoints.index')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'model', String, :desc => "Model Name", required: true
  param 'action', String, :desc => "Action Name", required: true
  param 'entity_id', String, :desc => "Entity ID"
  def index; end

  api :POST, '/endpoints', I18n.t('api.resource_description.descriptions.endpoints.index')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'model', String, :desc => "Model Name", required: true
  param 'action', String, :desc => "Action Name", required: true
  param 'entity_id', String, :desc => "Entity ID"
  def create; end

end
