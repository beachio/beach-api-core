module BeachApiCore
  class V1::TeamsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include TeamsDoc

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/team.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def create
      result = BeachApiCore::TeamCreate.call(params: team_params, user: current_user,
                                             application: current_application)
      if result.success?
        render_json_success(result.team, result.status, root: :team)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      authorize @team
      render_json_success(@team, :ok, root: :team)
    end

    def update
      authorize @team
      result = BeachApiCore::TeamUpdate.call(team: @team, params: team_params)
      if result.success?
        render_json_success(@team, result.status, root: :team)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @team
      if @team.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.beach_api_core/team.downcase')) }, :bad_request)
      end
    end

    private

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
