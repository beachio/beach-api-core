module BeachApiCore
  class V1::ServicesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include ServicesDoc
    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/service.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

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
      params.require(:service).permit(:title, :name, :description, :service_category_id,
                                      icon_attributes: %i(file base64))
    end
  end
end
