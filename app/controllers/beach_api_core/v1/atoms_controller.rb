module BeachApiCore
  class V1::AtomsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include AtomsDoc

    before_action :doorkeeper_authorize!, :authorize_instance_owner
    skip_before_action :get_resource, only: [:update, :destroy]

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      render_json_success({ atoms: BeachApiCore::Atom.all }, :ok)
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
      result = BeachApiCore::AtomUpdate.call(atom: atom, params: atom_params)
      if result.success?
        render_json_success(result.atom, result.status, root: :atom)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(@atom, :ok, root: :atom)
    end

    def destroy
      if atom.destroy
        render_json_success({ message: 'Atom was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'Could not remove atom' }, :bad_request)
      end
    end

    private

    def atom
      return BeachApiCore::Atom.find_by!(name: params[:name]) if params[:name]
      BeachApiCore::Atom.find(params[:id])
    end

    def authorize_instance_owner
      authorize Instance.current, :admin?
    end

    def atom_params
      params.require(:atom).permit(:kind, :atom_parent_id, :title)
    end
  end
end
