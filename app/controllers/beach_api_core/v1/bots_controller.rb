module BeachApiCore
  class V1::BotsController < BeachApiCore::V1::BaseController
    # before_action :doorkeeper_authorize!
    before_action :set_bot

    def dialog_flow
      client = ApiAiRuby::Client.new(:client_access_token => @bot.dialog_flow_client_access_token)
      response = client.text_request params[:message]
      render json: {message: response[:result][:fulfillment][:messages][0][:speech]}
    end

    private
    def set_bot
      unless @bot = BeachApiCore::Bot.find_by(uuid: params[:bot_uuid])
        render json: {msg: "Bot not found"}, status: 404
      end
    end

  end
end
