class CreateBeachApiCoreScreenControls < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_screen_controls do |t|
      t.string :name
      t.json :settings

      t.timestamps
    end
  end
end
