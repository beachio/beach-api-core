class AddLockedToBeachApiCoreFlows < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_flows, :locked, :boolean
  end
end
