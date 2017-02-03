class CreateBeachApiCoreRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_roles do |t|
      t.string :name, index: true, null: false
      t.references :keeper, polymorphic: true, index: true
      t.timestamps
    end
    add_index :beach_api_core_roles, [:name, :keeper_id, :keeper_type], unique: true,
              name: 'index_roles_on_name_and_keeper_id_and_keeper_type'
  end
end
