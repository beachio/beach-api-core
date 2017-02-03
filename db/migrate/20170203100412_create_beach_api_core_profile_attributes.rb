class CreateBeachApiCoreProfileAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_profile_attributes do |t|
      t.references :profile
      t.references :profile_custom_field
      t.string :value
      t.timestamps
    end
  end
end
