require_dependency "beach_api_core/application_controller"

# Allow our users to Connect with HumanAPI.
module BeachApiCore
  class ScreensController < ApplicationController
    include BeachApiCore::Concerns::ScreensConcern

    layout false
    before_action :authorize_user
    skip_before_action :verify_authenticity_token

    def view
      render template: "layouts/screens"
    end

    private

    def current_user
      @current_user ||= NuweHealth::User.find(session["user_id"]) rescue nil
    end

    def authorize_user
      redirect_to nuwe_health.new_session_path(back_url: nuwe_health.apps_path) unless current_user
    end

  end
end
