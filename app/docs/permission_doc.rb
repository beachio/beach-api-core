module PermissionDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/atoms/:atom_id/permission', 'List of rights for Atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"actions\": #{apipie_actions_response}"
  def index
  end
end
