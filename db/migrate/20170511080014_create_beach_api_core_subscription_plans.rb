class CreateBeachApiCoreSubscriptionPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_subscription_plans do |t|
      t.string :name
      t.string :stripe_id
      t.integer :amount
      t.string :interval
      t.integer :interval_count
      t.integer :trial_period_days

      t.timestamps
    end
  end
end
