require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    include BeachApiCore::Concerns::V1::BaseControllerConcern

    private

    def application_authorize!
      if !doorkeeper_token && request.headers["HTTP_AUTHORIZATION"].present?
        application_id, application_secret = request.headers["HTTP_AUTHORIZATION"].split(',')
        application_id.gsub!('application_id', '').to_s.strip!
        application_secret.gsub!('client_secret', '').to_s.strip!
        application = Doorkeeper::Application.find_by(uid: application_id)
        if application.blank? || application.secret != application_secret
          return render_json_error({ message: 'Unauthorized' }, :unauthorized)
        end
        @current_user = application.owner
      else
        doorkeeper_authorize!
      end
    end

    def authorize_instance_owner!
      authorize Instance.current, :admin?
    end
  end
end
