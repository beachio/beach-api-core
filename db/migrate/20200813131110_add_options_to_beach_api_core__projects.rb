class AddOptionsToBeachApiCoreProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_projects, :options, :json, default: {}
  end
end
