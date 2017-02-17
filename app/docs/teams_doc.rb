module TeamsDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :team do
    param :team, Hash, required: true do
      param :name, String, required: true
    end
  end

  api :POST, '/teams', 'Create a team'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :team
  example "\"team\": #{apipie_team_response} \nfail: 'Errors Description'"
  def create
  end

  api :GET, '/teams/:id', 'Get team'
  example "\"team\": #{apipie_team_response}"
  def show
  end

  api :PUT,  '/teams/:id', 'Update a team'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :team
  example "\"team\": #{apipie_team_response} \nfail: 'Errors Description'"
  def update
  end

  api :DELETE, '/teams/:id', 'Remove team'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Team was successfully deleted' \nfail: 'Could not remove team'"
  def destroy
  end
end
