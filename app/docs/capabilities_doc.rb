module CapabilitiesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/services/:service_id/capabilities', 'Create capability'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"service\": #{apipie_service_response} \nfail: 'Errors Description'"
  def create; end

  api :DELETE, '/services/:service_id/capabilities', 'Remove capability'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "fail: 'Errors Description'"
  def destroy; end
end
