module BeachApiCore
  class V1::ChannelsController < BeachApiCore::V1::BaseController
    include ChannelsDoc
    before_action :doorkeeper_authorize!
    before_action :ensure_entity_params

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/channel.other')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      render_json_success({ channels: channels }, :ok)
    end

    private

    def channels
      [user_channel, entity_channel].compact
    end

    def user_channel
      { channel: 'UserChannel', id: current_user.id }
    end

    def entity_channel
      return @_entity_channel if @_entity_channel
      return unless params[:entity]
      entity ||= Entity.find_by(entity_lookup_params)
      @_entity_channel = entity ? { channel: 'EntityChannel', id: entity.id } : nil
    end

    def entity_lookup_params
      params.require(:entity).permit(:uid, :kind)
    end

    def ensure_entity_params
      return unless params[:entity].present? && !(params[:entity][:uid].present? && params[:entity][:kind].present?)
      render_json_error({ message: I18n.t('api.errors.some_parameters_are_absent') }, :bad_request)
    end
  end
end
