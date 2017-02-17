module BeachApiCore
  class V1::UsersController < BeachApiCore::V1::BaseController
    include ::UsersDoc

    before_action :doorkeeper_authorize!, except: [:create]

    def create
      result = BeachApiCore::SignUp.call(user_create_params.merge(headers: request.headers['HTTP_AUTHORIZATION']))

      if result.success?
        render_json_success(result.user, result.status, keepers: [Instance.current], root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(current_user, :ok, keepers: [Instance.current, current_application], root: :user)
    end

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
