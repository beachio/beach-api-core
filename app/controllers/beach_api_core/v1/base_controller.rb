require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    include BeachApiCore::Concerns::V1::BaseControllerConcern

    private

    def explicit_application_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present? && application_authorized?
        return @current_user = @doorkeeper_application.owner
      end
      render_json_error({ message: 'Unauthorized' }, :unauthorized)
    end

    def application_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present?
        return render_json_error({ message: 'Unauthorized' }, :unauthorized) unless application_authorized?
        @current_user = @doorkeeper_application.owner
      else
        doorkeeper_authorize!
      end
    end

    def application_authorized?
      application_id, application_secret = request.headers['HTTP_AUTHORIZATION'].split(',')
      application_id.gsub!('application_id', '').to_s.strip!
      application_secret.gsub!('client_secret', '').to_s.strip!
      @doorkeeper_application = Doorkeeper::Application.find_by(uid: application_id)
      @doorkeeper_application.present? && @doorkeeper_application.secret == application_secret
    end

    def authorize_instance_owner!
      authorize Instance.current, :admin?
    end
  end
end
