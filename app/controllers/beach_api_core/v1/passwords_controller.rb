module BeachApiCore
  class V1::PasswordsController < BeachApiCore::V1::BaseController

    def create
      user = BeachApiCore::User.find_by(email: params[:email])
      result = BeachApiCore::ForgotPassword.call(user: user)
      if result.success?
        render_json_success({ user: BeachApiCore::UserSimpleSerializer.new(result.user) })
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::ResetPassword.call(params: reset_password_params)
      if result.success?
        render_json_success({ user: BeachApiCore::UserSimpleSerializer.new(result.user) })
      else
        render_json_error({ message: result.message }, result.status)
      end
    end


    def reset_password_params
      params.permit(:token, :password, :password_confirmation)
    end
  end
end
