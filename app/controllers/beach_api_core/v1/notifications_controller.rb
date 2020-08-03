require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class V1::NotificationsController < ApplicationController
    resource_description do
      api_base_url '/v1'
      name "Notifications"
    end

    def index
      @notifications = Article.all
    end

    def destroy
      @notification = Article.find(params[:id])
  
      if @notification.destroy
        render_json_success(@notification, :ok, root: :notification)
      else
        render_json_error({ message: "Could not remove notification"},
                          :bad_request)
      end
    end
  end
end
