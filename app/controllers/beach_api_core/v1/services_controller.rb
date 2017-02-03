module BeachApiCore
  class V1::ServicesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    def index
      authorize current_application, :manage?
      render_json_success(current_application.services, :ok, each_serializer: ServiceSerializer, root: :services)
    end

    def update
      authorize current_application, :manage?
      result = BeachApiCore::ServiceUpdate.call(service: @service, params: service_params)

      if result.success?
        render_json_success(@service, result.status, root: :service)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def service_params
      params.require(:service).permit(:title, :name, :description, :service_category_id, icon_attributes: [:file, :base64])
    end
  end
end