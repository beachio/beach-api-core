module AssignmentsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/assignments', 'Assign a role to user in current organisation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :assignment, Hash, required: true do
    param :role_id, Integer, required: true
    param :user_id, Integer, required: true
  end
  example "\"assignment\": #{apipie_assignment_response}"
  def create; end

  api :DELETE, '/assignments/:id', "Remove user's role"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "fail: 'Could not remove role'"
  def destroy; end
end
