module BeachApiCore
  class V1::ChatsController < BeachApiCore::V1::BaseController
    include ChatsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :application_authorize!, only: %i(create add_recipient)
    before_action :authenticate_service_for_doorkeeper_application, only: [:create, :add_recipient]
    before_action :doorkeeper_authorize!, except: %i(create add_recipient)
    before_action :authenticate_service_for_application, except: [:create, :add_recipient]
    before_action :get_resource, only: %i(read add_recipient)

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/chat.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      render_json_success(current_user.chats, :ok, root: :chats)
    end

    def create
      result = BeachApiCore::ChatCreate.call(user: current_user, keeper: keeper, params: chat_params)

      if result.success?
        render_json_success(result.chat, result.status, root: :chat, current_user: current_user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def add_recipient
      authorize @chat
      result = BeachApiCore::ChatAddRecipient.call(recipient: recipient, chat: @chat)

      if result.success?
        render_json_success(result.chat, result.status, root: :chat, current_user: current_user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def read
      authorize @chat
      result = BeachApiCore::ChatRead.call(chat: @chat, user: current_user)

      if result.success?
        render_json_success(result.chat, result.status, root: :chat, current_user: current_user)
      else
        render_json_error({ message: result.chat }, result.status)
      end
    end

    private

    def chat_params
      return unless params[:chat]
      params.require(:chat).permit(chats_users_attributes: [:user_id])
    end

    def keeper
      current_user || current_application
    end

    def recipient
      User.find(params[:chat][:recipient_id])
    end
  end
end
