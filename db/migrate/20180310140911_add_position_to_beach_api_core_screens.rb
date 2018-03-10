class AddPositionToBeachApiCoreScreens < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_screens, :position, :integer
  end
end
