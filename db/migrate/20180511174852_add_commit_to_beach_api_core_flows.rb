class AddCommitToBeachApiCoreFlows < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_flows, :commit, :string
  end
end
