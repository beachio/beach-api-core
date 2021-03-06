module BeachApiCore
  class V1::WebhooksController < BeachApiCore::V1::BaseController
    include WebhooksDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :explicit_application_with_user_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/webhook.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      webhooks = BeachApiCore::Webhook.where("keeper_id =  #{current_application.id} OR keeper_type = 'BeachApiCore::Instance'")
      render_json_success(webhooks, :ok, root: :webhooks)
    end

    def create
      result = BeachApiCore::WebhookCreate.call(params: webhook_params, uri: webhook_params[:uri], kind: webhook_params[:kind], keeper: current_application, :scores => webhook_params[:scores])

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
      params.require(:webhook).permit(:uri, :kind, :scores)
    end
  end
end
