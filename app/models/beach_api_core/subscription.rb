module BeachApiCore
  class Subscription < ApplicationRecord
    attr_accessor :cvc, :exp_year, :exp_month, :number
    belongs_to :plan, class_name: "BeachApiCore::Plan"
    belongs_to :owner, polymorphic: true

    validates :owner_type, :owner_id, :plan_id, presence: true
    validate :check_subscription_for, on: [:create, :update]
    validate :create_subscription, on: [:create]
    validate :change_subscription, on: [:update]

    before_destroy :cancel_subscription
    attr_accessor :not_change, :user_id, :organisation_id

    Stripe.api_key = ENV['LIVE_STRIPE_SECRET_KEY']

    def create_subscription
      set_stripe_key
      self.errors.add :subscription, "can't be created because you have active subscription" unless self.owner.nil? || self.owner.subscription.nil?
      return unless errors.blank?
      create_customer if self.owner.stripe_customer_token.blank?
      if self.owner.nil? || self.owner.stripe_customer_token.blank?
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
      set_stripe_key
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
      set_stripe_key
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

    def create_customer
      set_stripe_key
      client = self.owner
      unless client.nil?
        card_token = Stripe::Token.create(
            {
                card: {
                    number: number,
                    exp_month: exp_month,
                    exp_year: exp_year,
                    cvc: cvc
                }
            }
        )
        customer = Stripe::Customer.create(email: client.email, card: card_token.id)
        client.update_attribute(:stripe_customer_token, customer.id)
      end
    rescue Stripe::CardError => e
      render_json_error({:message => "Wrong card"})
    end

    private
    def check_subscription_for
      if self.plan.plan_for == 0
        type = "organisation"
      elsif self.plan.plan_for == 1
        type = "user"
      end
      self_plan = self.owner_type.gsub("BeachApiCore::",'').downcase

      self.errors.add :plan, "wrong for indicated type" unless self_plan == self.plan.plan_for || self_plan == type
    end

    def set_stripe_key
      Stripe.api_key = self&.plan&.test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
    end
  end

end