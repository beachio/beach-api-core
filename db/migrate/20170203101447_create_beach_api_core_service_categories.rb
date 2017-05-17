class CreateBeachApiCoreServiceCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_service_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
