module BeachApiCore
  class V1::ScreensController < BeachApiCore::V1::BaseController
    include ScreensDoc
    include BeachApiCore::Concerns::ScreensConcern

    # before_action :doorkeeper_authorize!
    before_action :check_app_uuid

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/screens.other')
    end


    def check_app_uuid
      unless application = Doorkeeper::Application.find_by(uid: params[:application_uid])
        render json: {msg: "Application not found"}, status: 404
      end
    end

  end
end
