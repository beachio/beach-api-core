require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    include BeachApiCore::Concerns::V1::BaseControllerConcern
    include BeachApiCore::Concerns::ActionPermissionsConcern

    private

    def explicit_application_with_user_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present? && application_authorized?
        return @current_user = @doorkeeper_application.owner
      end
      render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') }, :unauthorized)
    end

    def application_with_user_authorize!
      application_authorize! do
        @current_user = @doorkeeper_application.owner
      end
    end

    def application_authorize!
      if !doorkeeper_token && request.headers['HTTP_AUTHORIZATION'].present?
        unless application_authorized?
          return render_json_error({ message: I18n.t('api.resource_description.errors.unauthorized') },
                                   :unauthorized)
        end
        yield if block_given?
      else
        doorkeeper_authorize!
      end
    end

    def application_authorized?
      application_id, application_secret = request.headers['HTTP_AUTHORIZATION'].split(',')
      return false unless application_id.present? && application_secret.present?
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
