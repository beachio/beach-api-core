module BeachApiCore
  class V1::ProjectsController < BeachApiCore::V1::BaseController
    include ProjectsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    prepend_before_action :doorkeeper_authorize!
    prepend_before_action :authenticate_service_for_application

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/project.other')
    end

    def create
      result = ProjectCreate.call(params: project_params,
                                  user: current_user,
                                  organisation: current_organisation)
      if result.success?
        render_json_success(result.project, result.status, root: :project)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(@project, :ok, root: :project)
    end

    def update
      authorize @project
      result = ProjectUpdate.call(project: @project, params: project_params)
      if result.success?
        render_json_success(result.project, result.status, root: :project)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @project
      if @project.destroy
        render_json_success(@project, :ok, root: :project)
      else
        render_json_error({ message: @project.errors.full_messages }, :bad_request)
      end
    end

    def index
      if current_user
        @projects = current_scope.projects
        render json: @projects
      else
        render json: []
      end
    end

    private

    def resource_scope
      current_organisation.projects
    end

    def project_params
      params.require(:project).permit(:name, project_keepers_attributes: %i(keeper_id keeper_type))
    end
  end
end
