class CreateBeachApiCoreInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_instances do |t|
      t.string :name, null: false, unique: true, index: true
      t.timestamps
    end
  end
end
