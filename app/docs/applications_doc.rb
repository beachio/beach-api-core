module ApplicationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/applications', t('api.resource_description.descriptions.applications.list')
  example "\"applications\": [#{apipie_application_response}, ...]"
  def index
  end

  api :POST, '/applications', t('api.resource_description.descriptions.applications.create')
  param :application, Hash, required: true do
    param :name, String, required: true
    param :redirect_uri, String, required: true
  end
  example "\"application\": #{apipie_application_response} \n#{t('api.resource_description.fail',
                                                                 description: t('api.resource_description.fails.errors_description'))}"
  def create
  end

  api :GET, '/applications/:id', t('api.resource_description.descriptions.applications.get')
  example "\"application\": #{apipie_application_response}"
  def show
  end

  api :PUT,' /applications/:id', t('api.resource_description.descriptions.applications.update')
  param :application, Hash, required: true do
    param :name, String
  end
  example "\"application\": #{apipie_application_response} \n#{t('api.resource_description.fail',
                                                                 description: t('api.resource_description.fails.errors_description'))}"
  def update
  end

  api :DELETE, '/applications/:id', t('api.resource_description.descriptions.applications.delete')
  example t('api.resource_description.fail', description: t('api.resource_description.could_not_remove',
                                                            model: t('activerecord.models.beach_api_core/application.downcase')))
  def destroy
  end
end
