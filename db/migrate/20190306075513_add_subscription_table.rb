class AddSubscriptionTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_subscriptions do |t|
      t.references :plan
      t.references :owner, polymorphic: true, index: true
      t.string :stripe_subscription_id
    end
  end
end
