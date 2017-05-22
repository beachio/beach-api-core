module SessionsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/auth', t('api.resource_description.descriptions.sessions.authorize')
  param :session, Hash, required: true do
    param :email, String, required: true
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response}, \n\"access_token\": \"#{SecureRandom.hex(16)}\""
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  error code: 400, desc: t('api.resource_description.fail',
                           description: t('api.resource_description.fails.could_not_authorize_user')),
        meta: { message: t('api.resource_description.fail',
                           description: t('api.resource_description.fails.error_description')) }
  def create
  end
end
