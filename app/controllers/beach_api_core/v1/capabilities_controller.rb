module BeachApiCore
  class V1::CapabilitiesController < BeachApiCore::V1::BaseController
    before_action :doorkeeper_authorize!, :find_service

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    api :POST, '/services/:service_id/capabilities', 'Create capability'
    example "\"service\": #{apipie_service_response} \nfail: 'Errors Description'"
    def create
      authorize current_application, :manage?
      result = BeachApiCore::CapabilityCreate.call(service: @service, application: current_application)

      if result.success?
        render_json_success(@service, result.status, root: :service)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/services/:service_id/capabilities', 'Remove capability'
    example "success: 'Capability was successfully deleted' \nfail: 'Errors Description'"
    def destroy
      authorize current_application, :manage?
      @capability = @service.capabilities.find_by(application: current_application)
      if @capability.destroy
        render_json_success({ message: 'Capability was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'Could not remove capability' }, :bad_request)
      end
    end

    private

    def find_service
      @service = Service.find(params[:service_id])
    end
  end
end
