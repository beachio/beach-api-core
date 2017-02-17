module UsersDoc
  extend Apipie::DSL::Concern
  include BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/users', 'Create user'
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response} \nfail: 'Errors Description'"
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
      param :sex, %w(male female)
      param :'***', String, desc: 'Any custom field'
      param :avatar_attributes, Hash do
        param :file, File, desc: 'Postfield file'
        param :base64, String, desc: 'Encoded Base64 string'
      end
    end
  end
  example "\"user\": #{apipie_user_response} \nfail: 'Errors Description'"
  def update
  end
end
