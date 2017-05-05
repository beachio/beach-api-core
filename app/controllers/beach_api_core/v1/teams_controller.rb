module BeachApiCore
  class V1::TeamsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    include TeamsDoc

    before_action :doorkeeper_authorize!

    resource_description do
      name 'Teams'
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
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
        render_json_error({ message: 'Could not remove team' }, :bad_request)
      end
    end

    private

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
