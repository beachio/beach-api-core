module BeachApiCore
  class UserStripeToken < ApplicationRecord
    belongs_to :user
    belongs_to :application, class_name: 'Doorkeeper::Application'

    validates :user_id, :application_id, :stripe_customer_token, presence: true
    validates :stripe_customer_token, uniqueness: { scope: %i(user_id application_id) }
    before_destroy :delete_stripe_customer


    private

    def delete_stripe_customer
      Stripe.api_key = self.application.test_stripe ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['LIVE_STRIPE_SECRET_KEY']
      begin
        Stripe::Customer.delete(self.stripe_customer_token)
      rescue; end
    end
  end
end
