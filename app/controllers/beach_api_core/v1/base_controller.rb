require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    skip_before_action :verify_authenticity_token

    resource_description do
      api_version 'v1'
      formats ['json']
    end

    private

    def current_keepers
      [current_application, current_organisation, Instance.current].compact
    end

    def current_user
      @current_user ||= User.find(doorkeeper_token[:resource_owner_id]) if doorkeeper_token
    end

    def current_application
      @current_application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    end

    def current_organisation
      @current_organisation ||= current_user&.organisation
    end

    def render_json_success(json = {}, status = :ok, params = {})
      render({ json: json, status: status }.merge(params))
    end

    def render_json_error(error = {}, status = :internal_server_error)
      render json: { error: error }, status: status
    end
  end
end
