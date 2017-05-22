class AddActorToPermissions < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_permissions, :actor, :string
    add_index :beach_api_core_permissions, %i(atom_id actor keeper_id keeper_type),
              unique: true,
              name: 'index_bac_permissions_on_atom_id_and_actor_and_k_id_and_k_type'
  end
end
