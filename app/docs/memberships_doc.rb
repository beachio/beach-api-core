module MembershipsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/memberships', 'Create a membership'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :membership, Hash, required: true do
    param :member_id, String, required: true
    param :member_type, %w(Team User), required: true
    param :owner, [true, false]
  end
  param :group_id, String, required: true
  param :group_type, %w(Team Organisation), required: true
  example "\"team(or organisation)\": #{apipie_team_response} \nfail: 'Errors Description'"
  def create; end

  api :DELETE, '/memberships/:id', 'Destroy membership'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "fail: 'Could not remove membership'"
  def destroy; end
end
