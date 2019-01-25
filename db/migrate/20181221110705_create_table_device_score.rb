class CreateTableDeviceScore < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_device_scores do |t|
      t.references :device
      t.references :application
      t.integer :scores, default: 0
    end
  end
end
