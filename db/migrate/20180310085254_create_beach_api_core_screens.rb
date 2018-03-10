class CreateBeachApiCoreScreens < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_screens do |t|
      t.json :content
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
  end
end
