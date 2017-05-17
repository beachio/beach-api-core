class CreateBeachApiCoreSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_settings do |t|
      t.string :name, index: true, null: false, unique: true
      t.string :value
      t.references :keeper, polymorphic: true

      t.timestamps
    end
  end
end
