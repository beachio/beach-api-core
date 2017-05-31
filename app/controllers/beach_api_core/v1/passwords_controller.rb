module BeachApiCore
  class V1::PasswordsController < BeachApiCore::V1::BaseController
    include PasswordsDoc

    resource_description do
      name I18n.t('api.resource_description.resources.passwords')
    end

    def create
      user = BeachApiCore::User.find_by(email: params[:email])
      result = BeachApiCore::ForgotPassword.call(user: user)
      if result.success?
        render_json_success(result.user, :ok,
                            serializer: BeachApiCore::UserSimpleSerializer,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::ResetPassword.call(params: reset_password_params)
      if result.success?
        render_json_success(result.user, :ok,
                            serializer: BeachApiCore::UserSimpleSerializer,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def reset_password_params
      params.permit(:token, :password, :password_confirmation)
    end
  end
end
