module BeachApiCore
  class V1::ServiceCategoriesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include ServiceCategoriesDoc
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      authorize current_application, :manage?
      render_json_success(ServiceCategory.all, :ok, each_serializer: ServiceCategorySerializer, root: :service_categories)
    end

    def create
      authorize current_application, :manage?
      result = BeachApiCore::ServiceCategoryCreate.call(params: service_category_params)

      if result.success?
        render_json_success(result.service_category, result.status, root: :service_category)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

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
