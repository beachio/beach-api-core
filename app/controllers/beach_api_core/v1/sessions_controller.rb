module BeachApiCore
  class V1::SessionsController < BeachApiCore::V1::BaseController
    include SessionsDoc
    before_action :explicit_application_with_user_authorize!, only: [:create]
    resource_description do
      name I18n.t('api.resource_description.resources.authorization')
    end

    def create
      result = BeachApiCore::SignIn.call(session_params.merge(headers: request.headers['HTTP_AUTHORIZATION']))

      if result.success?
        @current_user = result.user
        render_json_success({ user: BeachApiCore::UserSerializer.new(result.user,
                                                                     root: :user,
                                                                     keepers: [BeachApiCore::Instance.current,
                                                                               current_organisation].compact,
                                                                     current_user: result.user,  current_application: current_application),
                              access_token: result.access_token&.token }, result.status)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      Doorkeeper::AccessToken.find_by(token: params[:id]).revoke
      render_json_success({success: true})
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
