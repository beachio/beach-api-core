module BeachApiCore
  class V1::RolesController < V1::BaseController
    include RolesDoc
    before_action :doorkeeper_authorize!

    def index
      # @todo: some more complex logic for roles?
      render_json_success(Role.all, :ok, each_serializer: RoleSerializer, root: :roles)
    end
  end
end