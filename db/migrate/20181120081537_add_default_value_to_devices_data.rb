class AddDefaultValueToDevicesData < ActiveRecord::Migration[5.1]
  def change
    change_column :beach_api_core_devices, :data, :json, default: {}
  end
end
