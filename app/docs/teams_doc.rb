module TeamsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :team do
    param :team, Hash, required: true do
      param :name, String, required: true
    end
  end

  api :POST, '/teams', t('api.resource_description.descriptions.teams.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :team
  example "\"team\": #{apipie_team_response} \n#{t('api.resource_description.fail',
                                                   description: t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :GET, '/teams/:id', t('api.resource_description.descriptions.teams.get')
  example "\"team\": #{apipie_team_response}"
  def show; end

  api :PUT,  '/teams/:id', t('api.resource_description.descriptions.teams.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :team
  example "\"team\": #{apipie_team_response} \n#{t('api.resource_description.fail',
                                                   description: t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :DELETE, '/teams/:id', t('api.resource_description.descriptions.teams.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example t('api.resource_description.fail', description: t('api.resource_description.could_not_remove',
                                                            model: t('activerecord.models.beach_api_core/team.downcase')))
  def destroy; end
end
