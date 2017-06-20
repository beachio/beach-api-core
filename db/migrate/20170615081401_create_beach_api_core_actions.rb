class CreateBeachApiCoreActions < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_actions do |t|
      t.string :name
      t.references :controller, foreign_key: { to_table: :beach_api_core_controllers }, null: false

      t.timestamps
    end
  end
end
