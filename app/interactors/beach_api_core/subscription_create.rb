module BeachApiCore
  class SubscriptionCreate
    include Interactor

    def call
      context.subscription = Subscription.new context.params
      context.subscription.owner = context.owner
      if context.subscription.save
        BeachApiCore::Invoice.last.update_attribute(:subscription_id, context.subscription.id)
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.subscription.errors.full_messages
      end
    end
  end
end