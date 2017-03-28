module PermissionsDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/atoms/:atom_id/permission', 'List of rights for Atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"actions\": #{apipie_actions_response}"
  def show
  end

  api :POST, '/v1/atoms/:atom_id/permission/set', 'Create/Update permission for Atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :permission, Hash, required: true do
    param :keeper_id, String, required: true
    param :keeper_type, %w(Organisation Team User Role), required: true
    param :actor, String, required: true
    param :actions, Array, required: true
  end
  example "{}"
  def set
  end
end
