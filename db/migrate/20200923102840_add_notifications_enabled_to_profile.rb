class AddNotificationsEnabledToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_profiles, :notifications_enabled, :boolean, null: false, default: false
  end
end
