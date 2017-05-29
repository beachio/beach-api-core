module ServicesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/services', I18n.t('api.resource_description.descriptions.services.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"services\": [#{apipie_service_response},...]"
  def index; end

  api :PUT, '/services/:id', I18n.t('api.resource_description.descriptions.services.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :service, Hash, required: true do
    param :title, String, required: true
    param :name, String
    param :description, String
    param :service_category_id, Integer, required: true
    param :icon_attributes, Hash do
      param :file, File, desc: I18n.t('api.resource_description.descriptions.params.postfield_file')
      param :base64, String, desc: I18n.t('api.resource_description.descriptions.params.encoded_string')
    end
  end
  example "\"service\": #{apipie_service_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end
end
