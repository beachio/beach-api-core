module BeachApiCore
  class V1::RolesController < V1::BaseController
    include RolesDoc
    before_action :doorkeeper_authorize!
    before_action :authenticate_service_for_application

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/role.other')
    end

    def index
      # @todo: some more complex logic for roles?
      render_json_success(Role.all, :ok, each_serializer: RoleSerializer, root: :roles)
    end
  end
end
