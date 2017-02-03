class CreateBeachApiCoreCapabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_capabilities do |t|
      t.references :service
      t.references :application
      t.timestamps
    end
  end
end
