module BeachApiCore
  class V1::NotificationsController < BeachApiCore::V1::BaseController
    include NotificationsDoc

    resource_description do
      api_base_url '/v1'
      name I18n.t('activerecord.models.beach_api_core/notification.other')
    end

    def index
      @notifications = BeachApiCore::Notification.all
      render json: @notifications, root: :notifications
    end

    def destroy
      @notification = BeachApiCore::Notification.find(params[:id])
      @notification.destroy
      if @notification.destroy
        render_json_success(@notification, :ok, root: :notification)
      else
        render_json_error({ message: @notification.errors.full_messages }, :bad_request)
      end
    end
  end
end
