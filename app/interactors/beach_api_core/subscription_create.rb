module BeachApiCore
  class SubscriptionCreate
    include Interactor

    before do
      context.params[:plan] = SubscriptionPlan.find(context.params[:plan_id])
    end

    def call
      sub = Payola::CreateSubscription.call(context.params, context.organisation)
      # @fixme: logger for debug purposes
      Rails.logger.info "new subscription #{sub.inspect}"
      context.status = :created
    end
  end
end
