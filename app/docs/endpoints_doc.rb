module EndpointsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/endpoints', I18n.t('api.resource_description.descriptions.endpoints.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param 'data', Object, :desc => "Submitting data in JSON format", required: true
  param 'handler', String, :desc => "Handler Name", required: true
  def create; end

end
