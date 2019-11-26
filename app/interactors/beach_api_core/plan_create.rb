module BeachApiCore
  class PlanCreate
    include Interactor

    def call
      context.plan = Plan.new context.params
      if context.plan.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.plan.errors.full_messages
      end
    end
  end
end