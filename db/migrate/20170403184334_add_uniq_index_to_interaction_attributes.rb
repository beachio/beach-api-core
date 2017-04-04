class AddUniqIndexToInteractionAttributes < ActiveRecord::Migration[5.0]
  def change
    add_index :beach_api_core_interaction_attributes, [:interaction_id, :key],
              unique: true, name: 'index_bac_interaction_attributes_on_interaction_id_and_key'
  end
end
