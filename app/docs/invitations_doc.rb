module InvitationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/invitations', t('api.resource_description.descriptions.invitations.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitations\": [#{apipie_invitation_response}, ...]"
  def index
  end

  api :POST, '/invitations', t('api.resource_description.descriptions.invitations.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :invitation, Hash, required: true do
    param :email, String, required: true
    param :role_ids, Array, required: true
    param :first_name, String
    param :last_name, String
  end
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitation\": #{apipie_invitation_response} \n#{t('api.resource_description.fail',
                                                               description: t('api.resource_description.fails.errors_description'))}"
  def create
  end

  api :DELETE, '/invitations/:id', t('api.resource_description.descriptions.invitations.revoke')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"invitation\": #{apipie_invitation_response}"
  def destroy
  end

  api :POST, '/invitations/:id/accept', t('api.resource_description.descriptions.invitations.accept')
  example "\"access_token\": \"#{SecureRandom.hex(16)}\"\n#{t('api.resource_description.fail',
                                                              description: t('api.resource_description.fails.errors_description'))}"
  def accept
  end
end
