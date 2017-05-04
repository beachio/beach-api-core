module BeachApiCore
  class V1::ProjectsController < BeachApiCore::V1::BaseController
    include ProjectsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    before_action :doorkeeper_authorize!

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

    private

    def project_params
      params.require(:project).permit(:name)
    end
  end
end
