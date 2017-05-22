module BeachApiCore
  class V1::CapabilitiesController < BeachApiCore::V1::BaseController
    include CapabilitiesDoc
    before_action :doorkeeper_authorize!, :find_service

    resource_description do
      name t('activerecord.models.beach_api_core/capability.other')
      error code: 403, desc: t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: t('api.resource_description.errors.unauthorized')
      error code: 400, desc: t('api.resource_description.errors.bad_request')
    end

    def create
      authorize current_application, :manage?
      result = BeachApiCore::CapabilityCreate.call(service: @service, application: current_application)

      if result.success?
        render_json_success(@service, result.status, root: :service)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize current_application, :manage?
      @capability = @service.capabilities.find_by(application: current_application)
      if @capability.destroy
        head :no_content
      else
        render_json_error({ message: t('api.errors.could_not_remove',
                                       model: t('activerecord.models.beach_api_core/capability.downcase')) },
                          :bad_request)
      end
    end

    private

    def find_service
      @service = Service.find(params[:service_id])
    end
  end
end
