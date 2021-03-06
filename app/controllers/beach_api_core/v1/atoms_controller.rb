module BeachApiCore
  class V1::AtomsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include AtomsDoc

    before_action :application_with_user_authorize!
    before_action :authenticate_service_for_doorkeeper_application

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/atom.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      user = params[:user_id] ? BeachApiCore::User.find(params[:user_id]) : current_user
      atoms = BeachApiCore::Atom.where(kind: params[:kind]).with_actions(params[:actions]).for_user(user)
      render_json_success(atoms, :ok,
                          current_user: user,
                          current_organisation: current_organisation,
                          root: :atoms)
    end

    def show
      render_json_success(@atom, :ok,
                          root: :atom,
                          current_user: current_user,
                          current_organisation: current_organisation)
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

    def destroy
      if @atom.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.beach_api_core/atom.downcase')) },
                          :bad_request)
      end
    end

    private

    def get_resource
      @atom ||= BeachApiCore::Atom.lookup!(params[:id])
    end

    def atom_params
      params.require(:atom).permit(:kind, :title, :name, :atom_parent_id)
    end
  end
end
