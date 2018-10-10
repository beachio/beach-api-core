module BeachApiCore
  class V1::BroadcastsController < BeachApiCore::V1::BaseController
    include BroadcastsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    before_action :explicit_application_with_user_authorize!
    before_action :validate_channel_name

    resource_description do
      name I18n.t('api.resource_description.resources.broadcasts')
    end

    def create
      result = BroadcastSend.call(params: channel_params, :application => current_application)
      if result.success?
        head :no_content
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def channel_params
      params.require(:channel).permit(:name, :id, payload: {})
    end

    def validate_channel_name
      return if %w(UserChannel EntityChannel).include?(channel_params[:name])
      render_json_error({ message: I18n.t('api.errors.should_be_valid_channel_name') }, :bad_request)
    end
  end
end
