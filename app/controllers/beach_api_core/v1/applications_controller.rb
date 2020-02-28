module BeachApiCore
  class V1::ApplicationsController < BeachApiCore::V1::BaseController
    include ApplicationsDoc
    before_action :doorkeeper_authorize!
    before_action :authenticate_service_for_application
    before_action :get_resource, only: %i(show update destroy upload_logo_image)

    resource_description do
      name I18n.t('activerecord.models.doorkeeper/application.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      authorize Instance.current, :developer_or_admin?
      render_json_success(current_user.applications, :ok,
                          each_serializer: AppSerializer, root: :applications)
    end

    def create
      authorize Instance.current, :developer_or_admin?

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
      authorize Instance.current, :developer_or_admin?
      authorize @application
      render_json_success(@application, :ok, serializer: AppSerializer, root: :application)
    end

    def update
      authorize Instance.current, :developer_or_admin?
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

    def upload_logo_image
      authorize Instance.current, :developer_or_admin?
      authorize @application
      result = BeachApiCore::DoorkeeperInteractor::ApplicationUpdate.call(
          application: @application, params: application_logo_params
      )

      if result.success?
        render_json_success(result.application, result.status,
                            serializer: AppSerializer, root: :application)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize Instance.current, :developer_or_admin?
      authorize @application

      if @application.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.doorkeeper/application.downcase')) },
                          :bad_request)
      end
    end

    private

    def get_resource
      @application = Doorkeeper::Application.find(params[:id])
    end

    def application_create_params
      params.require(:application).permit(:test_stripe, :name, :redirect_uri, :mail_type_band_color, :mail_type_band_text_color, :scores_for_invite, :scores_for_sign_up)
    end

    def application_update_params
      params.require(:application).permit(:test_stripe, :name, :mail_type_band_color, :mail_type_band_text_color, :scores_for_invite, :scores_for_sign_up)
    end

    def application_logo_params
      params.permit(:file)
    end
  end
end
