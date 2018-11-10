module BeachApiCore
  class V1::DevicesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include DevicesDoc

    # prepend_before_action :doorkeeper_authorize!

    before_action :set_device, only: [:update, :destroy, :show]

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/device.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      render_json_success(current_user.devices, :ok, root: :devices)
    end

    def show
      render_json_success(@device, :ok, root: :device)
    end

    def create
      puts request.headers
      result = BeachApiCore::DeviceCreate.call(user: current_user, params: device_params)

      if result.success?
        render_json_success(result.device, result.status, root: :device, current_user: current_user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::DeviceUpdate.call(device: @device, user: current_user, params: device_params)

      if result.success?
        render_json_success(result.device, result.status, root: :device, current_user: current_user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      result = BeachApiCore::DeviceDestroy.call(device: @device, user: current_user)

      if result.success?
        render_json_success(result.message, result.status, root: false, current_user: current_user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def device_params
      params.require(:device).permit(:name)
    end

    def set_device
      @device = current_user.devices.find(params[:id])
    end
  end
end
