module BeachApiCore
  class Membership < ApplicationRecord
    validates :group_id, uniqueness: { scope: %i(group_type member_id member_type) }
    validates :member, :group, presence: true

    belongs_to :member, polymorphic: true
    belongs_to :group, polymorphic: true
    after_create :set_quantity
    before_destroy :delete_quantity

    def set_quantity
      if self.group_type == "BeachApiCore::Organisation" && !self.group.subscription.nil?
        local_subscription = BeachApiCore::Subscription.find_by(:owner_id => self.group_id, :owner_type => self.group_type)
        Stripe.api_key = local_subscription&.plan&.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
        subscription = Stripe::Subscription.retrieve(local_subscription.stripe_subscription_id)
        Stripe::SubscriptionItem.update(subscription.items.data[0].id,{plan: subscription.items.data[0].plan.id, quantity: subscription.items.data[0].quantity+1})
      end
    end

    def delete_quantity
      if self.group_type == "BeachApiCore::Organisation" && !self.group.subscription.nil?
        local_subscription = BeachApiCore::Subscription.find_by(:owner_id => self.group_id, :owner_type => self.group_type)
        Stripe.api_key = local_subscription&.plan&.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
        subscription = Stripe::Subscription.retrieve(local_subscription.stripe_subscription_id)
        Stripe::SubscriptionItem.update(subscription.items.data[0].id,{plan: subscription.items.data[0].plan.id, quantity: subscription.items.data[0].quantity-1})
      end
    end
  end
end
