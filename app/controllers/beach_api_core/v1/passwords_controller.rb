module BeachApiCore
  class V1::PasswordsController < BeachApiCore::V1::BaseController
    include PasswordsDoc
    before_action :explicit_application_with_user_authorize!, only: %i(update create)
    skip_before_action :explicit_application_with_user_authorize!, only: [:update], :if => proc {|c| request.format.symbol == :html}
    resource_description do
      name I18n.t('api.resource_description.resources.passwords')
    end

    def create
      user = BeachApiCore::User.find_by(email: params[:email])
      result = BeachApiCore::ForgotPassword.call(user: user,
                                                 headers: request.headers['HTTP_AUTHORIZATION'])
      if result.success?
        render_json_success(result.user, :ok,
                            serializer: BeachApiCore::UserSimpleSerializer,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::ResetPassword.call(params: reset_password_params,
                                                headers: request.headers['HTTP_AUTHORIZATION'], request_symbol: request.format.symbol)
      if result.success?
        if request.format.symbol == :html
          @result = {:status => 'updated', message: []}
          render :success_restore
        else
          render_json_success(result.user, :ok,
                              serializer: BeachApiCore::UserSimpleSerializer,
                              root: :user)
        end
      else
        if request.format.symbol == :html
          @user = BeachApiCore::User.new
          @result = {:status => 'fail', message: result.message.is_a?(String) ? [result.message] : result.message}
          render :restore_password
        else
          render_json_error({ message: result.message }, result.status)
        end
      end
    end

    def success_restore
    end

    def restore_password
      @user = BeachApiCore::User.new
      @result = {:status => 'restore_reuest', message: []}
    end

    def reset_password_params
      params.permit(:token, :password, :password_confirmation)
    end
  end
end
