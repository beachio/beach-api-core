class RemoveIndexFromAssets < ActiveRecord::Migration[5.1]
  def change
    remove_index :beach_api_core_assets, name: "index_beach_api_core_assets_on_entity_type_and_entity_id"
  end
end
