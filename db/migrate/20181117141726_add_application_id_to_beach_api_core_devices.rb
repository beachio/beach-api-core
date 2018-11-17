class AddApplicationIdToBeachApiCoreDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_devices, :application_id, :string
  end
end
