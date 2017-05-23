module CapabilitiesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/services/:service_id/capabilities', I18n.t('api.resource_description.descriptions.capabilities.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"service\": #{apipie_service_response} \n#{I18n.t('api.resource_description.fail',
                                                              description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :DELETE, '/services/:service_id/capabilities', I18n.t('api.resource_description.descriptions.capabilities.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail', description: I18n.t('api.resource_description.fails.errors_description'))
  def destroy; end
end
