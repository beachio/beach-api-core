module BeachApiCore
  class V1::ServicesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    api :GET, '/services', 'Get list of services'
    example "\"services\": [#{apipie_service_response},...]"
    def index
      authorize current_application, :manage?
      render_json_success(current_application.services, :ok, each_serializer: ServiceSerializer, root: :services)
    end

    api :PUT, '/services/:id', 'Update service'
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
    example "\"service\": #{apipie_service_response} \n fail: 'Errors Description'"
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
