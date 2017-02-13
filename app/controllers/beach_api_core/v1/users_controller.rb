module BeachApiCore
  class V1::UsersController < BeachApiCore::V1::BaseController
    before_action :doorkeeper_authorize!, except: [:create]

    api :POST, '/users', 'Create user'
    param :user, Hash, required: true do
      param :email, String, required: true
      param :username, String
      param :password, String, required: true
    end
    example "\"user\": #{apipie_user_response} \nfail: 'Errors Description'"
    def create
      result = BeachApiCore::SignUp.call(user_create_params.merge(headers: request.headers['HTTP_AUTHORIZATION']))

      if result.success?
        render_json_success(result.user, result.status, keepers: [Instance.current], root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :GET, '/users/:id', 'Get current user'
    example "\"user\": #{apipie_user_response}"
    def show
      render_json_success(current_user, :ok, keepers: [Instance.current, current_application], root: :user)
    end

    api :PUT, '/users/:id', 'Update user'
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
      result = BeachApiCore::UserUpdate.call(user: current_user, params: user_update_params, keepers: [Instance.current, current_application])

      if result.success?
        render_json_success(current_user, result.status, keepers: [Instance.current, current_application], root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def user_create_params
      params.require(:user).permit(:email, :username, :password)
    end

    def user_update_params

      params.require(:user).permit(:email, :username,
                                   profile_attributes: custom_profile_fields.concat([:id, :first_name,
                                                                                     :last_name, :sex,
                                                                                     avatar_attributes: [:file, :base64]]))
    end

    def custom_profile_fields
      @_custom_fields ||= ProfileCustomField.where(keeper: [Instance.current, current_application]).pluck(:name)
    end
  end
end
