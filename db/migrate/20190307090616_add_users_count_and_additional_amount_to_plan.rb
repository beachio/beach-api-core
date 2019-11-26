class AddUsersCountAndAdditionalAmountToPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_plans, :users_count, :integer
    add_column :beach_api_core_plans, :amount_per_additional_user, :integer
  end
end
