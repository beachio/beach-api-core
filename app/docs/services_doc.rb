module ServicesDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/services', 'Get list of services'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"services\": [#{apipie_service_response},...]"
  def index
  end

  api :PUT, '/services/:id', 'Update service'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :service, Hash, required: true do
    param :title, String, required: true
    param :name, String
    param :description, String
    param :service_category_id, Integer, required: true
    param :icon_attributes, Hash do
      param :file, File, desc: 'Postfield file'
      param :base64, String, desc: 'Encoded Base64 string'
    end
  end
  example "\"service\": #{apipie_service_response} \nfail: 'Errors Description'"
  def update
  end
end
