require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class V1::NotificationsController < ApplicationController
    resource_description do
      api_base_url '/v1'
      name "Notifications"
    end

    def index
      @notifications = BeachApiCore::Notification.all
      render json: @notifications
    end

    def destroy
      @notification = BeachApiCore::Notification.find(params[:id])
      @notification.destroy
      head :no_content
    end
  end
end
