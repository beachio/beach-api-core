module InvitationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/invitations', I18n.t('api.resource_description.descriptions.invitations.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitations\": [#{apipie_invitation_response}, ...]"
  def index_doc; end

  api :POST, '/invitations', I18n.t('api.resource_description.descriptions.invitations.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :invitation, Hash, required: true do
    param :email, String, required: true
    param :role_ids, Array, required: true
    param :first_name, String
    param :last_name, String
  end
  param :group_type, %w(Team Organisation), required: true
  param :group_id, String, required: true
  example "\"invitation\": #{apipie_invitation_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create_doc; end

  api :DELETE, '/invitations/:id', I18n.t('api.resource_description.descriptions.invitations.revoke')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"invitation\": #{apipie_invitation_response}"
  def destroy_doc; end

  api :POST, '/invitations/:id/accept', I18n.t('api.resource_description.descriptions.invitations.accept')
  param :token, String
  example "\"access_token\": \"#{SecureRandom.hex(16)}\"
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def accept_doc; end
end
