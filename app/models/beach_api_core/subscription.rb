module BeachApiCore
  class Subscription < ApplicationRecord
    belongs_to :plan, class_name: "BeachApiCore::Plan"
    belongs_to :owner, polymorphic: true

    validates :owner_type, :owner_id, :plan_id, presence: true
    validate :check_subscription_for, on: [:create, :update]
    validate :create_subscription, on: [:create]
    validate :change_subscription, on: [:update]

    before_destroy :cancel_subscription
    attr_accessor :not_change, :user_id, :organisation_id

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    def create_subscription
      self.errors.add :subscription, "can't be created because you have active subscription" unless self.owner.subscription.nil?
      return unless errors.blank?
      if self.owner.nil? || self.owner.stripe_customer_token.nil?
        self.errors.add :owner, 'wrong subscription owner'
      else
        begin
          subs = Stripe::Subscription.create(
            {
              customer: self.owner.stripe_customer_token,
              items: [
                {
                  plan: self.plan.stripe_id,
                  quantity: 1
                }
              ]
            }
          )
          Stripe::Subscription.update(subs.id, {quantity: self.get_quantity}) if self.owner_type == "BeachApiCore::Organisation"
          self.stripe_subscription_id = subs.id
          if self.owner_type == 'BeachApiCore::Organisation' && !not_change
            self.owner.organisation_plan.nil? ? BeachApiCore::OrganisationPlan.create(:plan_id => self.plan_id, organisation_id: self.owner_id) : self.owner.organisation_plan.update_attribute(:plan_id, self.plan_id)
          end
        rescue => e
          self.errors.add :stripe_error, e.message
        end
      end
    end

    def change_subscription
      return unless self.plan_id_changed?
      return unless errors.blank?
      begin
        subscription = Stripe::Subscription.retrieve(self.stripe_subscription_id)
        Stripe::Subscription.update(
          self.stripe_subscription_id,
          {
            cancel_at_period_end: false,
            items: [
              {
                id: subscription.items.data[0].id,
                plan: self.plan.stripe_id,
              }
            ]
          }
        )
        Stripe::Subscription.update(subs.id, {quantity: self.get_quantity}) if self.owner_type == "BeachApiCore::Organisation"
        if owner_type == 'BeachApiCore::Organisation' && !not_change
          self.owner.organisation_plan.nil? ? BeachApiCore::OrganisationPlan.create(:plan_id => self.plan_id, organisation_id: self.owner_id) : self.owner.organisation_plan.update_attribute(:plan_id, self.plan_id)
        end
      rescue => e
        self.errors.add :stripe_error, e.message
      end
    end

    def cancel_subscription
      begin
        sub = Stripe::Subscription.retrieve(self.stripe_subscription_id)
        if sub.current_period_end > Time.now.to_i
          invoice = Stripe::Invoice.retrieve(sub.latest_invoice)
          time_left = sub.current_period_end - Time.now.to_i
          refund_sum = (time_left * invoice.amount_due)/(sub.current_period_end-sub.current_period_start)
          Stripe::Refund.create({charge: invoice.charge, amount: refund_sum})
        end
        sub.delete
      rescue => e
        self.errors.add :error, e.message unless e.message.match?(/No such subscription:/)
      end
      throw(:abort) if self.errors.present?
      BeachApiCore::OrganisationPlan.find_by(:organisation_id => self.owner_id, :plan_id => self.plan_id).destroy if self.owner_type == "BeachApiCore::Organisation" && !self.owner.plan.nil?
    end

    def get_quantity
      quantity = BeachApiCore::Membership.where(:group_type => self.owner_type, :group_id => self.owner_id).pluck(:member_id, :group_type, :group_id).uniq.count
      quantity
    end

    private
    def check_subscription_for
      self.errors.add :plan, "wrong for indicated type" unless self.owner_type.gsub("BeachApiCore::",'').downcase == self.plan.plan_for
    end
  end

end