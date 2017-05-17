class CreateBeachApiCoreServices < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_services do |t|
      t.string :title
      t.string :name
      t.text :description
      t.references :service_category
      t.timestamps
    end
  end
end
