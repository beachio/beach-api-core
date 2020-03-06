module BeachApiCore
  class Subscription < ApplicationRecord
    attr_accessor :cvc, :exp_year, :exp_month, :number
    belongs_to :plan, class_name: "BeachApiCore::Plan"
    belongs_to :owner, polymorphic: true
    belongs_to :application, class_name: 'Doorkeeper::Application'

    before_validation :set_application
    validates :owner_type, :owner_id, :plan_id, :application_id, presence: true
    validate :check_subscription_for, on: [:create, :update]
    validate :create_subscription, on: [:create]
    validate :change_subscription, on: [:update]
    validate :plan_and_application_in_one_mode, on: [:create, :update]

    before_destroy :cancel_subscription
    attr_accessor :user_id, :organisation_id, :owner_stripe_mode

    Stripe.api_key = ENV['LIVE_STRIPE_SECRET_KEY']

    def create_subscription
      return unless errors.blank?
      set_stripe_key
      self.errors.add :subscription, "can't be created because you have active subscription" unless self.owner.nil? || self.owner.subscription.nil?
      return unless errors.blank?
      token = organisation_is_owner? ? self.owner.stripe_customer_token : self.owner.stripe_token(self.application.id)&.stripe_customer_token
      token = create_customer if token.blank?
      return unless errors.blank?
      if self.owner.nil? || token.blank?
        self.errors.add :owner, 'wrong subscription owner'
      else
        begin
          subs = Stripe::Subscription.create(
            {
              customer: token,
              items: [
                {
                  plan: self.plan.stripe_id,
                  quantity: 1
                }
              ]
            }
          )
          Stripe::Subscription.update(subs.id, {quantity: self.get_quantity}) if organisation_is_owner?
          self.stripe_subscription_id = subs.id
          if organisation_is_owner?
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
        Stripe::Subscription.update(subscription.id, {quantity: self.get_quantity}) if organisation_is_owner?
        if organisation_is_owner?
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
          Stripe::Refund.create({charge: invoice.charge, amount: refund_sum}) if invoice.charge.present? && refund_sum > 0
        end
        sub.delete
      rescue => e
        self.errors.add :error, e.message unless e.message.match?(/No such subscription:/)
      end
      throw(:abort) if self.errors.present?
      BeachApiCore::OrganisationPlan.find_by(:organisation_id => self.owner_id, :plan_id => self.plan_id).destroy if organisation_is_owner? && !self.owner.plan.nil?
    end

    def get_quantity
      quantity = BeachApiCore::Membership.where(:group_type => self.owner_type, :group_id => self.owner_id).pluck(:member_id, :group_type, :group_id).uniq.count
      quantity
    end

    def create_customer
      set_stripe_key
      client = self.owner
      if client.present? && card_data_present?
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
        organisation_is_owner? ? client.update_attribute(:stripe_customer_token, customer.id) : client.create_stripe_customer(customer.id, self.application_id)
        customer.id
      elsif !card_data_present?
        self.errors.add :stripe_customer, "not exists"
      end
    rescue Stripe::CardError => e
      render_json_error({:message => "Wrong card"})
    end

    private

    def plan_and_application_in_one_mode
      return unless errors.blank?
      self.errors.add :plan, "stripe modes mismatch with application stripe mode" unless self.plan.test == self.application.test_stripe
    end

    def organisation_is_owner?
      self.owner_type == 'BeachApiCore::Organisation'
    end

    def check_subscription_for
      return unless errors.blank?
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

    def set_application
      self.application = self.owner.application if organisation_is_owner?
    end

    def card_data_present?
       number.present? && exp_month.present? && exp_year.present? && cvc.present?
    end
  end

end