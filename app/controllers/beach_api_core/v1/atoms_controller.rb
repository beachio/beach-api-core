module BeachApiCore
  class V1::AtomsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include AtomsDoc

    before_action :doorkeeper_authorize!, :authorize_instance_owner!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      user = params[:user_id] ? BeachApiCore::User.find(params[:user_id]) : current_user
      atoms = BeachApiCore::Atom.where(kind: params[:kind]).with_actions(params[:actions]).for_user(user)
      render_json_success(atoms, :ok,
                          current_user: user, current_organisation: current_organisation,
                          root: :atoms)
    end

    def create
      result = BeachApiCore::AtomCreate.call(params: atom_params)
      if result.success?
        render_json_success(result.atom, result.status, root: :atom)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::AtomUpdate.call(atom: @atom, params: atom_params)
      if result.success?
        render_json_success(result.atom, result.status, root: :atom)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(@atom, :ok, root: :atom,
                          current_user: current_user, current_organisation: current_organisation)
    end

    def destroy
      if @atom.destroy
        render_json_success({ message: 'Atom was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'Could not remove atom' }, :bad_request)
      end
    end

    private

    def get_resource
      @atom ||= BeachApiCore::Atom.lookup!(params[:id])
    end

    def atom_params
      params.require(:atom).permit(:kind, :atom_parent_id, :title)
    end
  end
end
