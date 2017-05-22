class CreateBeachApiCoreProfileCustomFields < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_profile_custom_fields do |t|
      t.string :name
      t.string :title
      t.integer :status
      t.references :keeper,
                   polymorphic: true,
                   index: { name: 'index_profile_custom_fields_on_keeper_type_and_keeper_id' }
      t.timestamps
    end
  end
end
