class AddIndexToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_index :beach_api_core_permissions, :actions
  end
end
