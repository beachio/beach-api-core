module BeachApiCore
  class Plan < ApplicationRecord
    validates :name, :plan_for, :interval, :stripe_id, :currency, :amount, presence: true
    validates :users_count, numericality: {less_than_or_equal_to: 10}, if: :organisation?
    validates :amount, numericality: {greater_than: 0}
    validates :users_count, :amount_per_additional_user, numericality: {greater_than: 0}, presence: true, if: :organisation?
    validates :stripe_id, :name, uniqueness: true
    validate :create_stripe_plan, on: [:create]

    has_many :organisation_plans, dependent: :destroy
    has_many :plan_items, dependent: :destroy

    has_many :users, class_name: "BeachApiCore::User"
    has_many :subscriptions, class_name: "BeachApiCore::Subscription", dependent: :destroy

    before_destroy :delete_stripe_plan

    accepts_nested_attributes_for :plan_items, allow_destroy: true
    attr_readonly :plan_for, :interval, :stripe_id, :amount, :amount_per_additional_user, :users_count, :currency

    Stripe.api_key = ENV['LIVE_STRIPE_SECRET_KEY']

    def organisation?
      self.plan_for == "organisation"
    end

    def delete_stripe_plan
      set_stripe_key
      if self.stripe_id.present?
        begin
          stripe_plan = Stripe::Plan.retrieve(self.stripe_id)
          stripe_product = Stripe::Product.retrieve(stripe_plan.product)
          stripe_plan.delete
          stripe_product.delete
        rescue => e
          self.errors.add e.message unless e.message.match?(/No such plan/)
        end
      end
      throw(:abort) if self.errors.present?
    end

    def create_stripe_plan
      set_stripe_key
      return unless self.errors.blank?
      trial = self.trial_period_days.nil? ? 0 : self.trial_period_days

      if self.organisation?
        Stripe::Plan.create(
          {
            interval: self.interval,
            trial_period_days: trial,
            product: {
              name: self.name,
            },
            billing_scheme: "tiered",
            tiers: [{flat_amount: self.amount, up_to: self.users_count},{unit_amount: self.amount_per_additional_user, up_to:"inf"}],
            tiers_mode: "graduated",
            currency: self.currency,
            id: self.stripe_id,
          }
        )
      else
        self.users_count = 1
        self.amount_per_additional_user = 0
        Stripe::Plan.create(
        {
            amount: self.amount,
            interval: self.interval,
            trial_period_days: trial,
            product: { name: self.name },
            currency: self.currency,
            id: self.stripe_id,
          }
        )
      end
    rescue => e
      self.errors.add :stripe_error, e.message
    end

    def set_stripe_key
      Stripe.api_key = test ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
    end
  end
end
