module AtomsDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :atom do
    param :atom, Hash, required: true do
      param :title, String, required: true
      param :kind, String, required: true
      param :atom_parent_id, Integer
    end
  end

  api :POST, '/atoms', 'Create an atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :atom
  example "\"atom\": #{apipie_atom_response} \nfail: 'Errors Description'"
  def create
  end

  api :PUT, '/atoms', 'Update an atom by id or name'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :id, String, desc: 'can be either atom id or name'
  param_group :atom
  example "\"atom\": #{apipie_atom_response} \nfail: 'Errors Description'"
  def update
  end

  api :DELETE, '/atoms/:id', 'Remove an atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Atom was successfully deleted' \nfail: 'Could not remove atom'"
  def show
  end

  api :GET, '/atoms', 'List of atoms'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :user_id, Integer
  param :kind, String, required: true
  param :actions, Array, required: true
  example "\"atoms\": [#{apipie_atom_response}, ...]"
  def index
  end

  api :DELETE, '/atoms', 'Remove an atom by id or name'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :id, String, desc: 'can be either atom id or name'
  example "success: 'Atom was successfully deleted' \nfail: 'Could not remove atom'"
  def destroy
  end
end
