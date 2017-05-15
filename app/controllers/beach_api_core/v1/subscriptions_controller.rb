module BeachApiCore
  class V1::SubscriptionsController < BeachApiCore::V1::BaseController
    include SubscriptionsDoc
    include ::Payola::StatusBehavior

    before_action :doorkeeper_authorize!

    def create
      authorize current_organisation, :update?
      result = SubscriptionCreate.call(params: subscription_params,
                                       organisation: current_organisation)
      if result.success?
        render_json_success({ message: 'success' }, result.status)
      else
        render_json_error({ message: 'error' }, result.status)
      end
    end

    private

    def subscription_params
      params.require(:subscription).permit(:plan_id, :stripeToken, :stripeEmail)
    end
  end
end
