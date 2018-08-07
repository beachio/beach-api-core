require_dependency "beach_api_core/application_controller"

# Allow our users to Connect with HumanAPI.
module BeachApiCore
  class ScreensController < ApplicationController
    include BeachApiCore::Concerns::ScreensConcern

    layout false
    skip_before_action :verify_authenticity_token

    def beach_chat
      respond_to do |format|
        format.js {
          render template: "beach_api_core/screens/beach_chat.js"
        }
      end
    end

    def view
      render template: "layouts/screens"
    end

  end
end
