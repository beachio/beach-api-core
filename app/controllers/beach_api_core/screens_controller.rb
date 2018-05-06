require_dependency "beach_api_core/application_controller"

# Allow our users to Connect with HumanAPI.
module BeachApiCore
  class ScreensController < ApplicationController
    include BeachApiCore::Concerns::ScreensConcern

    layout false
    before_action :authenticate_admin_user!
    skip_before_action :verify_authenticity_token

    def view
      render template: "layouts/screens"
    end

  end
end
