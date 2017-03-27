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

  api :PUT, '/atoms/:id', 'Update an atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :atom
  example "\"atom\": #{apipie_atom_response} \nfail: 'Errors Description'"
  def update
  end

  api :GET, '/atoms/:id', 'Get an atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"atom\": #{apipie_atom_response} \nfail: 'Errors Description'"
  def show
  end

  api :DELETE, '/atoms/:id', 'Remove an atom'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Atom was successfully deleted' \nfail: 'Could not remove atom'"
  def destroy
  end
end
