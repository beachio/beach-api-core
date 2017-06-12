module BeachApiCore
  class V1::MessagesController < BeachApiCore::V1::BaseController
    include MessagesDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!
    before_action :load_chat

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/message.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      authorize @chat
      render_json_success(@chat.messages, :ok, root: :messages)
    end

    def create
      authorize @chat
      result = BeachApiCore::MessageCreate.call(chat: @chat, current_user: current_user, params: message_params)

      if result.success?
        render_json_success(result.message, result.status, current_user: current_user, root: :message)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def load_chat
      @chat = Chat.find(params[:chat_id])
    end

    def message_params
      params.require(:message).permit(:message)
    end
  end
end
