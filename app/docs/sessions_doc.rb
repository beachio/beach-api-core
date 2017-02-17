module SessionsDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/auth', 'Authorize user'
  param :session, Hash, required: true do
    param :email, String, required: true
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response}"
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  error code: 400, desc: 'Can not authorize user', meta: { message: 'Error description' }
  def create
  end
end