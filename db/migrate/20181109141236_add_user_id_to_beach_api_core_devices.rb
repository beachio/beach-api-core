class AddUserIdToBeachApiCoreDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_devices, :user_id, :integer
    add_index :beach_api_core_devices, :user_id
  end
end
