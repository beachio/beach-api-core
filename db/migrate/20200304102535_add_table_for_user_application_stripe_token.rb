class AddTableForUserApplicationStripeToken < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_user_stripe_tokens do |t|
      t.string :stripe_customer_token, null: false
      t.references :user
      t.references :application
    end
  end
end
