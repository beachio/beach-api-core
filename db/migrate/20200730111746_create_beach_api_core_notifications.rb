class CreateBeachApiCoreNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_notifications do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }
      t.text :message
      t.integer :kind
      t.boolean :sent

      t.timestamps
    end
  end
end
