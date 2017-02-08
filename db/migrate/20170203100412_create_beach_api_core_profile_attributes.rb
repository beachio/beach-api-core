class CreateBeachApiCoreProfileAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_profile_attributes do |t|
      t.references :profile
      t.references :profile_custom_field, index: { name: 'index_profile_attributes_on_profile_custom_field_id' }
      t.string :value
      t.timestamps
    end
    add_index :beach_api_core_profile_attributes, [:profile_id, :profile_custom_field_id], unique: true
  end
end
