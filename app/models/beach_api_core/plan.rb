module BeachApiCore
  class Plan < ApplicationRecord

    validates :name, :plan_for, :amount, :interval, :stripe_id, presence: true
    validates :stripe_id, :name, uniqueness: true
    validate :create_stripe_plan, on: [:create]

    has_many :organisation_plans, dependent: :destroy
    has_many :plan_items, dependent: :destroy

    has_many :users, class_name: "BeachApiCore::User"
    has_many :subscriptions, class_name: "BeachApiCore::Subscription", dependent: :destroy
    enum plan_for: %i(organisation user)

    before_destroy :delete_stripe_plan

    accepts_nested_attributes_for :plan_items, allow_destroy: true
    attr_readonly :plan_for, :interval, :stripe_id, :amount

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    def delete_stripe_plan
      begin
        stripe_plan = Stripe::Plan.retrieve(self.stripe_id)
        stripe_plan.delete
      rescue => e
        self.errors.add e.message unless e.message.match?(/No such plan/)
      end
      throw(:abort) if self.errors.present?
    end

    def create_stripe_plan
      return unless self.errors.blank?

      Stripe::Plan.create(
        {
          amount: self.amount,
          interval: self.interval,
          product: {
            name: self.name,
          },
          currency: 'usd',
          id: self.stripe_id,
        }
      )
    rescue => e
      self.errors.add :stripe_error, e.message
    end
  end
end
