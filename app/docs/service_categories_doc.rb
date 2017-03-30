module ServiceCategoriesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern
  def_param_group :service_category do
    param :service_category, Hash, required: true do
      param :name, String, required: true
    end
  end

  api :GET, '/service_categories', 'Service categories list'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"service_categories\": [#{apipie_service_category_response}, ...]"
  def index
  end

  api :POST, '/service_categories', 'Create service category'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :service_category
  example "\"service_category\": #{apipie_service_category_response} \nfail: 'Errors Description'"
  def create
  end

  api :PUT, '/service_categories/:id', 'Update service category'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :service_category
  example "\"service_category\": #{apipie_service_category_response} \nfail: 'Errors Description'"
  def update
  end
end
