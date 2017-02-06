class MoveKeeperFromRole < ActiveRecord::Migration[5.0]
  def change
    change_table :beach_api_core_assignments do |t|
      t.references :keeper, polymorphic: true, index: true
    end
    remove_column :beach_api_core_roles, :keeper_id
    remove_column :beach_api_core_roles, :keeper_type
  end
end
