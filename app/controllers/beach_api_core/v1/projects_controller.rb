module BeachApiCore
  class V1::ProjectsController < BeachApiCore::V1::BaseController
    include ProjectsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    prepend_before_action :doorkeeper_authorize!

    resource_description do
      name 'Projects'
    end

    def create
      result = ProjectCreate.call(params: project_params, user: current_user)
      if result.success?
        render_json_success(result.project, result.status, root: :project)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(@project, :ok, root: :project)
    end

    def destroy
      if @project.destroy
        render_json_success(@project, :ok, root: :project)
      else
        render_json_error({ message: @project.errors.full_messages }, :bad_request)
      end
    end

    private

    def resource_scope
      current_user.projects
    end

    def project_params
      params.require(:project).permit(:name)
    end
  end
end
