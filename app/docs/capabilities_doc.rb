module CapabilitiesDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/services/:service_id/capabilities', 'Create capability'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"service\": #{apipie_service_response} \nfail: 'Errors Description'"
  def create
  end

  api :DELETE, '/services/:service_id/capabilities', 'Remove capability'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Capability was successfully deleted' \nfail: 'Errors Description'"
  def destroy
  end
end
