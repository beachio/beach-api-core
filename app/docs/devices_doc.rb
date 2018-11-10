module DevicesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/devices', I18n.t('api.resource_description.descriptions.devices.index')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def index; end

  api :GET, '/devices/:id', I18n.t('api.resource_description.descriptions.devices.show')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"device\": #{apipie_device_response}"
  def show; end

  api :POST, '/devices', I18n.t('api.resource_description.descriptions.devices.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :device, Hash, required: true do
    param :name, String, required: true
  end
  example "\"device\": #{apipie_device_response}"
  def create; end

  api :PUT, '/devices/:id', I18n.t('api.resource_description.descriptions.devices.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :device, Hash, required: true do
    param :name, String, required: true
  end
  example "\"device\": #{apipie_device_response}"
  def update; end

  api :DELETE, '/devices/:id', I18n.t('api.resource_description.descriptions.devices.destroy')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def destroy; end
end
