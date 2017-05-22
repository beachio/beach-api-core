module BeachApiCore
  class V1::PermissionsController < BeachApiCore::V1::BaseController
    include PermissionsDoc
    before_action :application_authorize!, :find_atom

    resource_description do
      name t('activerecord.models.beach_api_core/permission.other')
      error code: 403, desc: t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: t('api.resource_description.errors.unauthorized')
      error code: 400, desc: t('api.resource_description.errors.bad_request')
    end

    def show
      actions = current_user.permissions_for(@atom, current_organisation)
      render_json_success({ actions: actions }, :ok)
    end

    def set
      result = BeachApiCore::PermissionSet.call(params: permission_params, atom: @atom)

      if result.success?
        render_json_success({}, result.status)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def permission_params
      params.require(:permission).permit(:keeper_id, :keeper_type, :actor, actions: [])
    end


    def find_atom
      @atom ||= BeachApiCore::Atom.lookup!(params[:atom_id])
    end
  end
end
