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
        subscription = Stripe::Subscription.retrieve(BeachApiCore::Subscription.find_by(:owner_id => self.group_id, :owner_type => self.group_type).stripe_subscription_id)
        Stripe::SubscriptionItem.update(subscription.items.data[0].id,{plan: subscription.items.data[0].plan.id, quantity: subscription.items.data[0].quantity+1})
      end
    end

    def delete_quantity
      if self.group_type == "BeachApiCore::Organisation" && !self.group.subscription.nil?
        subscription = Stripe::Subscription.retrieve(BeachApiCore::Subscription.find_by(:owner_id => self.group_id, :owner_type => self.group_type).stripe_subscription_id)
        Stripe::SubscriptionItem.update(subscription.items.data[0].id,{plan: subscription.items.data[0].plan.id, quantity: subscription.items.data[0].quantity-1})
      end
    end
  end
end
