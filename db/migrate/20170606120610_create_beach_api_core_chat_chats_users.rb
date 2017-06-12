class CreateBeachApiCoreChatChatsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_chat_chats_users do |t|
      t.references :chat, foreign_key: { to_table: :beach_api_core_chats }, null: false
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false

      t.timestamps
    end
  end
end
