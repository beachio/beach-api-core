module BeachApiCore
  class V1::PlansController < BeachApiCore::V1::BaseController
    include PlansDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('api.resource_description.resources.plans')
    end

    def index
      render_json_success(Plan.all, :ok,
                          each_serializer: PlanSerializer,
                          root: :plans)
    end

    def create
      if admin
        result = PlanCreate.call(params: plan_params)
        if result.success?
          render_json_success(result.plan, :ok, serializer: BeachApiCore::PlanSerializer, root: :plan)
        else
          render_json_error({ message: result.message }, result.status)
        end
      else
        render_json_error({message: "Wrong permissions"})
      end
    end

    def show
      plan = Plan.find_by(id: params[:id])
      if plan.nil?
        render_json_error({message: "There are no such plan"})
      else
        render_json_success(plan)
      end
    end

    def destroy
      if admin
        plan = Plan.find_by(id: params[:id])
        if plan.nil?
          render_json_error({message: "Could not remove plan"})
        else
          begin
            if plan.destroy
              head :no_content
            else
              render_json_error({message: "Could not remove plan"})
            end
          rescue => e
            render_json_error({message: "Could not remove plan"})
          end
        end
      end
    end

    private

    def plan_params
      params.require(:plan).permit(:name, :amount, :interval, :stripe_id, :plan_for, :currency, :trial_period_days, :amount_per_additional_user, :users_count)
    end
  end
end