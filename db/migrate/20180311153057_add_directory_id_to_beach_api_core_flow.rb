class AddDirectoryIdToBeachApiCoreFlow < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_flows, :directory_id, :integer
  end
end
