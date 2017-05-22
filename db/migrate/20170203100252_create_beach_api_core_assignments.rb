class CreateBeachApiCoreAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_assignments do |t|
      t.references :role
      t.references :user
      t.references :keeper, polymorphic: true, index: true
      t.timestamps
    end
    add_index :beach_api_core_assignments, %i(role_id user_id keeper_id keeper_type),
              unique: true, name: 'index_bac_assignments_on_r_id_and_u_id_and_k_id_and_k_type'
  end
end
