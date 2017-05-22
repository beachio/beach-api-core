module BeachApiCore
  class V1::ApplicationsController < BeachApiCore::V1::BaseController
    include ApplicationsDoc
    before_action :doorkeeper_authorize!
    before_action :get_resource, only: [:show, :update, :destroy]

    resource_description do
      name t('activerecord.models.beach_api_core/application.other')
      error code: 403, desc: t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: t('api.resource_description.errors.unauthorized')
      error code: 400, desc: t('api.resource_description.errors.bad_request')
    end

    def index
      authorize Instance.current, :developer?
      render_json_success(current_user.applications, :ok,
                          each_serializer: AppSerializer, root: :applications)
    end

    def create
      authorize Instance.current, :developer?

      result = BeachApiCore::DoorkeeperInteractor::ApplicationCreate.call(
        user: current_user, params: application_create_params
      )

      if result.success?
        render_json_success(result.application, result.status,
                            serializer: AppSerializer, root: :application)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      authorize Instance.current, :developer?
      authorize @application
      render_json_success(@application, :ok, serializer: AppSerializer, root: :application)
    end

    def update
      authorize Instance.current, :developer?
      authorize @application

      result = BeachApiCore::DoorkeeperInteractor::ApplicationUpdate.call(
        application: @application, params: application_update_params
      )

      if result.success?
        render_json_success(result.application, result.status,
                            serializer: AppSerializer, root: :application)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize Instance.current, :developer?
      authorize @application

      if @application.destroy
        head :no_content
      else
        render_json_error({ message: t('api.errors.could_not_remove',
                                       model: t('activerecord.models.beach_api_core/application.downcase')) },
                          :bad_request)
      end
    end

    private

    def get_resource
      @application = Doorkeeper::Application.find(params[:id])
    end

    def application_create_params
      params.require(:application).permit(:name, :redirect_uri)
    end

    def application_update_params
      params.require(:application).permit(:name)
    end
  end
end
