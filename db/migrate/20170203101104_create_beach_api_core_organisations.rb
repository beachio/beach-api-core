class CreateBeachApiCoreOrganisations < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_organisations do |t|
      t.string :name
      t.references :application
      t.timestamps
    end
  end
end
