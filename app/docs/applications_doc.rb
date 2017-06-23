module ApplicationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/applications', I18n.t('api.resource_description.descriptions.applications.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"applications\": [#{apipie_application_response}, ...]"
  def index; end

  api :POST, '/applications', I18n.t('api.resource_description.descriptions.applications.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :application, Hash, required: true do
    param :name, String, required: true
    param :redirect_uri, String, required: true
  end
  example "\"application\": #{apipie_application_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :GET, '/applications/:id', I18n.t('api.resource_description.descriptions.applications.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"application\": #{apipie_application_response}"
  def show; end

  api :PUT, '/applications/:id', I18n.t('api.resource_description.descriptions.applications.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :application, Hash, required: true do
    param :name, String
  end
  example "\"application\": #{apipie_application_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :DELETE, '/applications/:id', I18n.t('api.resource_description.descriptions.applications.delete')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.doorkeeper/application.downcase')))
  def destroy; end
end
