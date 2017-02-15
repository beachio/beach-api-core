module BeachApiCore
  class V1::SessionsController < BeachApiCore::V1::BaseController
    resource_description do
      name 'Authorization'
    end

    api :POST, '/auth', 'Authorize user'
    param :session, Hash, required: true do
      param :email, String, required: true
      param :password, String, required: true
    end
    example "\"user\": #{apipie_user_response}"
    error code: 400, desc: 'Can not authorize user', meta: { message: 'Error description' }
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