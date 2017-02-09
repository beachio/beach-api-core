class CreateBeachApiCoreRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_roles do |t|
      t.string :name, index: true, null: false
      t.timestamps
    end
  end
end
