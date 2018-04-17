class CreateBeachApiCoreScreensControls < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_screens_controls do |t|
      t.integer :screen_id
      t.integer :control_id
      t.integer :position

      t.timestamps
    end
  end
end
