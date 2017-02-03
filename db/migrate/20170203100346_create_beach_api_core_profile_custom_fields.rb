class CreateBeachApiCoreProfileCustomFields < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_profile_custom_fields do |t|
      t.string :name
      t.string :title
      t.integer :status
      t.references :keeper, polymorphic: true
      t.timestamps
    end
  end
end
