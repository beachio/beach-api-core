module AtomsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :atom do
    param :atom, Hash, required: true do
      param :title, String, required: true
      param :kind, String, required: true
      param :atom_parent_id, Integer
    end
  end

  api :POST, '/atoms', t('api.resource_description.descriptions.atoms.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :atom
  example "\"atom\": #{apipie_atom_response} \n#{t('api.resource_description.fail',
                                                   description: t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :PUT, '/atoms', t('api.resource_description.descriptions.atoms.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :id, String, desc: t('api.resource_description.descriptions.atoms.can_be_atom_id_or_name'), required: true
  param_group :atom
  example "\"atom\": #{apipie_atom_response} \n#{t('api.resource_description.fail',
                                                   description: t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :GET, '/atoms/:id', t('api.resource_description.descriptions.atoms.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"atom\": #{apipie_atom_response} \n#{t('api.resource_description.fail',
                                                   description: t('api.resource_description.fails.errors_description'))}"
  def show; end

  api :GET, '/atoms', t('api.resource_description.descriptions.atoms.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :user_id, Integer
  param :kind, String, required: true
  param :actions, Array, required: true
  example "\"atoms\": [#{apipie_atom_response}, ...]"
  def index; end

  api :DELETE, '/atoms', t('api.resource_description.descriptions.atoms.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :id, String, desc: t('api.resource_description.descriptions.atoms.can_be_atom_id_or_name')
  example t('api.resource_description.fail', description: t('api.resource_description.could_not_remove',
                                                            model: t('activerecord.models.beach_api_core/atom.downcase')))
  def destroy; end
end
