class CreateBeachApiCoreControllersServices < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_controllers_services do |t|
      t.string :name
      t.references :service, foreign_key: { to_table: :beach_api_core_services }, null: false

      t.timestamps
    end
  end
end
