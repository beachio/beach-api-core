module BeachApiCore
  class SubscriptionPlanCreate
    include Interactor

    def call
      context.subscription_plan = SubscriptionPlan.new context.params
      if context.subscription_plan.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.subscription_plan.errors.full_messages
      end
    end
  end
end
