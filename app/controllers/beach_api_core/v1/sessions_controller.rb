module BeachApiCore
  class V1::SessionsController < BeachApiCore::V1::BaseController
    include SessionsDoc
    resource_description do
      name 'Authorization'
    end

    def create
      result = BeachApiCore::SignIn.call(session_params.merge(headers: request.headers['HTTP_AUTHORIZATION']))

      if result.success?
        render_json_success(
            { user: BeachApiCore::UserSerializer.new(result.user, root: :user),
              access_token: result.access_token&.token },
            result.status
        )
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
