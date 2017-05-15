module BeachApiCore
  class V1::SubscriptionPlansController < BeachApiCore::V1::BaseController
    include SubscriptionPlansDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    before_action :doorkeeper_authorize!

    def index
      render_json_success(SubscriptionPlan.all, :ok,
                          each_serializer: SubscriptionPlanSerializer,
                          root: :subscription_plans)
    end

    def create
      # @todo: authorize ...?
      result = SubscriptionPlanCreate.call(params: subscription_plan_params)
      if result.success?
        render_json_success(result.subscription_plan, result.status, root: :subscription_plan)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def subscription_plan_params
      params.require(:subscription_plan).permit(:name, :amount, :interval, :stripe_id)
    end
  end
end
