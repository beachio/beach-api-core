class AddAncestryToBeachApiCoreDirectories < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_directories, :ancestry, :string
    add_index :beach_api_core_directories, :ancestry
  end
end
