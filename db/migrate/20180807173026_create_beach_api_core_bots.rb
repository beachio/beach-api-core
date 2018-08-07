class CreateBeachApiCoreBots < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_bots do |t|
      t.uuid :uuid
      t.integer :application_id
      t.string :name
      t.integer :flow_id
      t.string :dialog_flow_client_access_token

      t.timestamps
    end
  end
end
