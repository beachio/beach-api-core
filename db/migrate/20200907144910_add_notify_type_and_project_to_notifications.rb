class AddNotifyTypeAndProjectToNotifications < ActiveRecord::Migration[5.1]
  def change
    change_table :beach_api_core_notifications do |t|
      t.references :project, foreign_key: { to_table: :vulcan_core_projects }, type: :uuid
      t.integer :notify_type, null: false
    end
  end
end
