class CreateBeachApiCoreMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_messages do |t|
      t.references :chat, foreign_key: { to_table: :beach_api_core_chats }, null: false
      t.references :sender, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.text :message

      t.timestamps
    end
  end
end
