module UsersDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/users', 'Create user'
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response}, \n\"access_token\": \"#{SecureRandom.hex(16)}\"\nfail: 'Errors Description'"
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create
  end

  api :GET, '/user', 'Get current user'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"user\": #{apipie_user_response}"
  def show
  end

  api :PUT, '/user', 'Update current user'
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
      param :'***', String, desc: 'Any custom field'
      param :avatar_attributes, Hash do
        param :file, File, desc: 'Postfield file'
        param :base64, String, desc: 'Encoded Base64 string'
      end
    end
    param :user_preferences_attributes, Array do
      param :id, Integer, required: true
      param :preferences, Hash, required: true
    end
  end
  example "\"user\": #{apipie_user_response} \nfail: 'Errors Description'"
  def update
  end

  api :POST, '/users/:id/confirm', 'Confirm user'
  param :confirmation_token, String, required: true
  example "\"user\": #{apipie_user_response}"
  def confirm
  end
end
