class AddCurrencyToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_plans, :currency, :string
  end
end
