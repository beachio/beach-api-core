module BeachApiCore
  class V1::TeamsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    api :POST, '/teams', 'Create a team'
    param :team, Hash, required: true do
      param :name, String, required: true
    end
    example "\"team\": #{apipie_team_response}"
    def create
      result = BeachApiCore::TeamCreate.call(params: team_params, user: current_user,
                                             application: current_application)
      if result.success?
        render_json_success(result.team, result.status, root: :team)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :GET, '/teams/:id', 'Get team'
    example "\"team\": #{apipie_team_response}"
    def show
      authorize @team
      render_json_success(@team, :ok, root: :team)
    end

    api :PUT,  '/teams/:id', 'Update a team'
    param :team, Hash, required: true do
      param :name, String
    end
    example "\"team\": #{apipie_team_response}"
    def update
      authorize @team
      result = BeachApiCore::TeamUpdate.call(team: @team, params: team_params)
      if result.success?
        render_json_success(@team, result.status, root: :team)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/teams/:id', 'Remove team'
    def destroy
      authorize @team
      if @team.destroy
        render_json_success({ message: 'Team was successfully deleted' }, :ok)
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
