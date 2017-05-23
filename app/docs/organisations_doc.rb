module OrganisationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :organisation do
    param :organisation, Hash, required: true do
      param :name, String, required: true
      param :logo_properties, Hash
      param :logo_image_attributes, Hash do
        param :file, File, desc: I18n.t('api.resource_description.descriptions.params.postfield_file')
        param :base64, String, desc: I18n.t('api.resource_description.descriptions.params.encoded_string')
      end
    end
  end

  api :GET, '/organisations', I18n.t('api.resource_description.descriptions.organisations.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisations\": [#{apipie_organisation_response}, ...]"
  def index; end

  api :POST, '/organisations', I18n.t('api.resource_description.descriptions.organisations.create')
  param_group :organisation
  example "\"organisation\": #{apipie_organisation_response} \n#{I18n.t('api.resource_description.fail',
                                                                        description: I18n.t('api.resource_description.fails.errors_description'))}"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def create; end

  api :GET, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisation\": #{apipie_organisation_response}"
  def show; end

  api :PUT, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :organisation
  example "\"organisation\": #{apipie_organisation_response} \n#{I18n.t('api.resource_description.fail',
                                                                        description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :DELETE, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail', description: I18n.t('api.errors.could_not_remove',
                                                                      model: I18n.t('activerecord.models.beach_api_core/organisation.downcase')))
  def destroy; end

  api :GET, '/organisations/users', I18n.t('api.resource_description.descriptions.organisations.get_users')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :term, String, desc: I18n.t('api.resource_description.descriptions.params.term_for_autocomplete')
  example "\"users\": [#{apipie_organisation_user_response}, ...]"
  def users; end

  api :PUT, '/organisations/:id/current', I18n.t('api.resource_description.descriptions.organisations.set_context')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def current; end
end
