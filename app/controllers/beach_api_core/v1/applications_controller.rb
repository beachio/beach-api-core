module BeachApiCore
  class V1::ApplicationsController < BeachApiCore::V1::BaseController
    before_action :doorkeeper_authorize!
    before_action :get_resource, only: [:show, :update, :destroy]

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    api :GET, '/applications', 'Get list of applications'
    example "\"applications\": [#{apipie_application_response}, ...]"
    def index
      authorize Instance.current, :developer?
      render_json_success(current_user.applications, :ok, each_serializer: AppSerializer, root: :applications)
    end

    api :POST, '/applications', 'Create an application'
    param :application, Hash, required: true do
      param :name, String, required: true
      param :redirect_uri, String, required: true
    end
    example "\"application\": #{apipie_application_response} \nfail: 'Errors Description'"
    def create
      authorize Instance.current, :developer?

      result = BeachApiCore::DoorkeeperInteractor::ApplicationCreate.call(user: current_user,
                                                                          params: application_create_params)

      if result.success?
        render_json_success(result.application, result.status, serializer: AppSerializer, root: :application)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :GET, '/applications/:id', 'GET an application'
    example "\"application\": #{apipie_application_response}"
    def show
      authorize Instance.current, :developer?
      authorize @application
      render_json_success(@application, :ok, serializer: AppSerializer, root: :application)
    end

    api :PUT,' /applications/:id', 'Update an application'
    param :application, Hash, required: true do
      param :name, String
    end
    example "\"application\": #{apipie_application_response} \nfail: 'Errors Description'"
    def update
      authorize Instance.current, :developer?
      authorize @application

      result = BeachApiCore::DoorkeeperInteractor::ApplicationUpdate.call(application: @application,
                                                                          params: application_update_params)

      if result.success?
        render_json_success(result.application, result.status, serializer: AppSerializer, root: :application)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/applications/:id', 'Delete an application'
    example "success: 'Application has been destroyed' \nfail: 'Could not remove application'"
    def destroy
      authorize Instance.current, :developer?
      authorize @application

      if @application.destroy
        render_json_success({ message: 'Application has been destroyed' }, :ok)
      else
        render_json_error({ message: 'Could not remove application' }, :bad_request)
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
