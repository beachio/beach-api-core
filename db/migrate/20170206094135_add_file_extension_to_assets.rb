class AddFileExtensionToAssets < ActiveRecord::Migration[5.0]
  def change
    add_column :beach_api_core_assets, :file_extension, :string, index: true
  end
end
