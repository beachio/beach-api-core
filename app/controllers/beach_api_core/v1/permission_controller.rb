module BeachApiCore
  class V1::PermissionController < BeachApiCore::V1::BaseController
    include PermissionDoc
    before_action :doorkeeper_authorize!, :find_atom

    resource_description do
      error code: 401, desc: 'Unauthorized'
    end

    def index
      actions = current_user.permissions_for(@atom, current_organisation)
      render_json_success({ actions: actions }, :ok)
    end

    private

    def find_atom
      @atom ||= BeachApiCore::Atom.lookup!(params[:atom_id])
    end
  end
end
