class CreateBeachApiCoreAccessLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_access_levels do |t|
      t.string :title
      t.string :name, index: true, null: false

      t.timestamps
    end
  end
end
