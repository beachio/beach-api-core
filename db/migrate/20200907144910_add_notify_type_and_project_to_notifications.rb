class AddNotifyTypeAndProjectToNotifications < ActiveRecord::Migration[5.1]
  def change
    change_table :beach_api_core_notifications do |t|
      t.uuid :project_id
      t.integer :notify_type, null: false
    end

    add_index :beach_api_core_notifications, :project_id
  end
end
