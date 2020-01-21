class ChangeSubscriptionOwnerIdToEmail < ActiveRecord::Migration[5.1]
  def change
    rename_column :beach_api_core_organisations, :subscription_owner_id, :email
    change_column :beach_api_core_organisations, :email, :string
  end
end
