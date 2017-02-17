module InvitationsDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/invitations', 'Create an invitation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :invitation, Hash, required: true do
    param :email, String, required: true
  end
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitation\": #{apipie_invitation_response} \nfail: 'Errors Description'"
  def create
  end
end
