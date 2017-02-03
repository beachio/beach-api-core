class CreateBeachApiCoreAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_assets do |t|
      t.string :file_id
      t.string :file_filename
      t.integer :file_size
      t.string :file_content_type, index: true
      t.references :entity, polymorphic: true
      t.timestamps
    end
    add_index :beach_api_core_assets, [:entity_id, :entity_type]
  end
end
