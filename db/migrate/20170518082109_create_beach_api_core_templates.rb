class CreateBeachApiCoreTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_templates do |t|
      t.string :name, index: true, null: false, unique: true
      t.string :value
      t.integer :kind, null: false, default: 0

      t.timestamps
    end
  end
end
