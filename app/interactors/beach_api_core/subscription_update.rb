class BeachApiCore::SubscriptionUpdate
  include Interactor

  def call
    context.subscription.assign_attributes context.params
    context.subscription.owner_stripe_mode = context.owner_stripe_mode
    if context.subscription.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.subscription.errors.full_messages
    end
  end
end
