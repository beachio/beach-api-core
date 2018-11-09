class AddTokenToBeachApiCoreDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_devices, :token, :string
    add_column :beach_api_core_devices, :data, :json
  end
end
