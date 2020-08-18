class CreateBeachApiCoreNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_notifications do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.text :message
      t.integer :kind, null: false
      t.boolean :sent, default: false

      t.timestamps
    end
  end
end
