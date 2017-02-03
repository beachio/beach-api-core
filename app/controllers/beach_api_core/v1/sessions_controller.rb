module BeachApiCore
  class V1::SessionsController < BeachApiCore::V1::BaseController
    def create
      result = BeachApiCore::SignIn.call(session_params)

      if result.success?
        render_json_success(result.user, result.status, root: :user)
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