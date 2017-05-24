module PasswordsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/password', I18n.t('api.resource_description.descriptions.passwords.send')
  param :email, String, required: true
  example "\"user\": #{apipie_user_response}"
  def create; end

  api :PUT, '/password', I18n.t('api.resource_description.descriptions.passwords.reset')
  param :token, String, required: true, desc: I18n.t('api.resource_description.descriptions.params.reset_password_token')
  param :password, String, required: true
  param :password_confirmation, String, required: true
  example "\"user\": #{apipie_user_response}"
  def update; end
end
