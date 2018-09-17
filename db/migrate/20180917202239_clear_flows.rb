class ClearFlows < ActiveRecord::Migration[5.1]
  def change
    drop_table :beach_api_core_screens
    drop_table :beach_api_core_flows
    drop_table :beach_api_core_bots
  end
end
