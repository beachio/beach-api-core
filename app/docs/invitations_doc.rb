module InvitationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/invitations', 'Get a list of pending invitations for group'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitations\": [#{apipie_invitation_response}, ...]"
  def index
  end

  api :POST, '/invitations', 'Create an invitation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :invitation, Hash, required: true do
    param :email, String, required: true
    param :role_id, Integer, required: true
    param :first_name, String
    param :last_name, String
  end
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitation\": #{apipie_invitation_response} \nfail: 'Errors Description'"
  def create
  end

  api :DELETE, '/invitations/:id', 'Revoke an invitation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"invitation\": #{apipie_invitation_response}"
  def destroy
  end
end
