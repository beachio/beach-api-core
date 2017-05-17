class AddStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_users, :status, :integer
  end
end
