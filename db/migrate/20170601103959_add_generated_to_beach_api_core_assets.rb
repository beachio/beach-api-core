class AddGeneratedToBeachApiCoreAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_assets, :generated, :boolean, null: false, default: false
  end
end
