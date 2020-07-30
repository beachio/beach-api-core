require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class V1::NotificationsController < ApplicationController
    resource_description do
      api_base_url '/v1'
      name "Notifications"
    end

    def index
    end

    def destroy
    end
  end
end
