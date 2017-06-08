class CreateBeachApiCoreMessagesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_messages_users do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.references :message, foreign_key: { to_table: :beach_api_core_messages }, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
