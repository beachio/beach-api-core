module RolesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/roles', t('api.resource_description.descriptions.roles.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"roles\": [#{apipie_role_response}, ...]"
  def index
  end
end
