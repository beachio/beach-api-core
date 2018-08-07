module BeachApiCore
  class V1::ScreensController < BeachApiCore::V1::BaseController
    include ScreensDoc
    include BeachApiCore::Concerns::ScreensConcern

    # before_action :doorkeeper_authorize!
    before_action :check_bot_uuid

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/screens.other')
    end


    def check_bot_uuid
      unless @bot = BeachApiCore::Bot.find_by(uuid: params[:bot_uuid])
        render json: {msg: "Bot not found"}, status: 404
      end
    end

  end
end
