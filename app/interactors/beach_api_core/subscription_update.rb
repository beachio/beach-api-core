class BeachApiCore::SubscriptionUpdate
  include Interactor

  def call
    if context.subscription.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.subscription.errors.full_messages
    end
  end
end
