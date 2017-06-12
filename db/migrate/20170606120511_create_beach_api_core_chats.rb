class CreateBeachApiCoreChats < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_chats do |t|
      t.references :keeper, polymorphic: true, index: true

      t.timestamps
    end
  end
end
