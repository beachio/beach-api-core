module BeachApiCore::Concerns::V1::BaseControllerConcern
  extend ActiveSupport::Concern

  included do
    skip_before_action :verify_authenticity_token

    resource_description do
      api_version 'v1'
      formats ['json']
    end

    private

    def require_organisation!
      raise BeachApiCore::Exception::NotAcceptable unless current_organisation
    end

    def current_keepers
      [current_application, current_organisation, BeachApiCore::Instance.current].compact
    end

    def current_user
      @current_user ||= doorkeeper_token&.user
    end

    def current_application
      if doorkeeper_token&.application_id || @doorkeeper_application
        @current_application ||= Doorkeeper::Application
                                     .find_by(id: doorkeeper_token&.application_id || @doorkeeper_application&.id)
      end
    end

    def current_organisation
      # TODO: remove after frontend support multiple organisation
      doorkeeper_token.update(organisation: current_user.organisations.first) if doorkeeper_token &&
          !doorkeeper_token.organisation_id && current_user.organisations.first
      @current_organisation ||= current_user.organisations
                                    .find_by(id: doorkeeper_token&.organisation_id)
    end

    def render_json_success(json = {}, status = :ok, params = {})
      render({ json: json, status: status }.merge(params))
    end

    def render_json_error(error = {}, status = :internal_server_error)
      render json: { error: error }, status: status
    end
  end
end
