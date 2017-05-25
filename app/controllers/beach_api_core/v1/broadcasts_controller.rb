module BeachApiCore
  class V1::BroadcastsController < BeachApiCore::V1::BaseController
    include BroadcastsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    before_action :explicit_application_authorize!

    resource_description do
      name I18n.t('api.resource_description.resources.broadcasts')
    end

    def create
      result = BroadcastSend.call(params: broadcast_params)
      if result.success?
        head :no_content
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def broadcast_params
      params.require(:broadcast).permit(:user_id, payload: {})
    end
  end
end
