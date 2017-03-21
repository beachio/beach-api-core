module RolesDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/roles', 'Get list of available roles'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"roles\": [#{apipie_role_response}, ...]"
  def index
  end
end
