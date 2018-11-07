module UsersDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/users', I18n.t('api.resource_description.descriptions.users.create')
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response}, \n\"access_token\": \"#{SecureRandom.hex(16)}\"
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create; end

  api :GET, '/user', I18n.t('api.resource_description.descriptions.users.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"user\": #{apipie_user_response}"
  def show; end

  api :PUT, '/users/confirm_user/:id', "Confirm user with indicated id"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
  "message": "User with id: 48 was successfully confirmed"
}'
  def force_confirm_user; end

  api :PUT, '/user', I18n.t('api.resource_description.descriptions.users.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :profile_attributes, Hash do
      param :id, Integer, required: true
      param :first_name, String
      param :last_name, String
      param :current_password, String
      param :password, String
      param :password_confirmation, String
      param :sex, %w(male female)
      param :birth_date, Date, desc: I18n.t('api.resource_description.descriptions.params.birth_date')
      param :'***', String, desc: I18n.t('api.resource_description.descriptions.params.any_custom_field')
      param :avatar_attributes, Hash do
        param :file, File, desc: I18n.t('api.resource_description.descriptions.params.postfield_file')
        param :base64, String, desc: I18n.t('api.resource_description.descriptions.params.encoded_string')
      end
      param :current_age, Integer, desc: I18n.t('api.resource_description.descriptions.params.current_age')
    end
    param :user_preferences_attributes, Array do
      param :id, Integer, required: true
      param :preferences, Hash, required: true
    end
  end
  example "\"user\": #{apipie_user_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :POST, '/users/:id/confirm', I18n.t('api.resource_description.descriptions.users.confirm')
  param :confirmation_token, String, required: true
  example "\"user\": #{apipie_user_response}"
  def confirm; end
end
