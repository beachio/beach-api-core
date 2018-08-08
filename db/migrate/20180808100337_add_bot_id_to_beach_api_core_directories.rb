class AddBotIdToBeachApiCoreDirectories < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_directories, :bot_id, :integer
  end
end
