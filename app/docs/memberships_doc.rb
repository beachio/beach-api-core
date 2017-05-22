module MembershipsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/memberships', t('api.resource_description.descriptions.memberships.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :membership, Hash, required: true do
    param :member_id, String, required: true
    param :member_type, %w(Team User), required: true
    param :owner, [true, false]
  end
  param :group_id, String, required: true
  param :group_type, %w(Team Organisation), required: true
  example "\"team(or organisation)\": #{apipie_team_response} \n#{t('api.resource_description.fail',
                                                                    description: t('api.resource_description.fails.errors_description'))}"
  def create
  end

  api :DELETE, '/memberships/:id', t('api.resource_description.descriptions.memberships.destroy')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example t('api.resource_description.fail', description: t('api.resource_description.could_not_remove',
                                                            model: t('activerecord.models.beach_api_core/membership.downcase')))
  def destroy
  end
end
