module BeachApiCore
  class V1::ServiceCategoriesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end
    def_param_group :service_category do
      param :service_category, Hash, required: true do
        param :name, String, required: true
      end
    end

    api :GET, '/service_categories', 'Service categories list'
    header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
    example "\"service_categories\": [#{apipie_service_category_response}, ...]"
    def index
      authorize current_application, :manage?
      render_json_success(ServiceCategory.all, :ok, each_serializer: ServiceCategorySerializer, root: :service_categories)
    end

    api :POST, '/service_categories', 'Create service category'
    header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
    param_group :service_category
    example "\"service_category\": #{apipie_service_category_response} \nfail: 'Errors Description'"
    def create
      authorize current_application, :manage?
      result = BeachApiCore::ServiceCategoryCreate.call(params: service_category_params)

      if result.success?
        render_json_success(result.service_category, result.status, root: :service_category)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :PUT, '/service_categories/:id', 'Update service category'
    header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
    param_group :service_category
    example "\"service_category\": #{apipie_service_category_response} \nfail: 'Errors Description'"
    def update
      authorize current_application, :manage?
      result = BeachApiCore::ServiceCategoryUpdate.call(service_category: @service_category, params: service_category_params)

      if result.success?
        render_json_success(@service_category, result.status, root: :service_category)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def service_category_params
      params.require(:service_category).permit(:name)
    end
  end
end
