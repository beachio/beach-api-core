module PasswordsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/password', 'Send forgot password email'
  param :email, String, required: true
  example "\"user\": #{apipie_user_response}"
  def create; end

  api :PUT, '/password', "Reset user's password"
  param :token, String, required: true, desc: 'Reset password token'
  param :password, String, required: true
  param :password_confirmation, String, required: true
  example "\"user\": #{apipie_user_response}"
  def update; end
end
