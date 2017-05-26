module BeachApiCore
  class V1::WebhooksController < BeachApiCore::V1::BaseController
    include WebhooksDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :explicit_application_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/webhook.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      render_json_success(current_application.webhooks, :ok, root: :webhooks)
    end

    def create
      result = BeachApiCore::WebhookCreate.call(params: webhook_params, application: current_application)

      if result.success?
        render_json_success(result.webhook, result.status, root: :webhook)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @webhook
      if @webhook.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.webhook.downcase')) }, :bad_request)
      end
    end

    private

    def webhook_params
      params.require(:webhook).permit(:uri, :kind)
    end
  end
end
