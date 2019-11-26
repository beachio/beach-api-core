class AddStripeColumnsToPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_plans, :stripe_id, :string
    add_column :beach_api_core_plans, :amount, :integer
    add_column :beach_api_core_plans, :interval, :string
    add_column :beach_api_core_plans, :interval_amount, :integer
    add_column :beach_api_core_plans, :trial_period_days, :integer
    add_column :beach_api_core_plans, :plan_for, :integer
  end
end
