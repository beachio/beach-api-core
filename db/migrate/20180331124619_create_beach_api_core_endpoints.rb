class CreateBeachApiCoreEndpoints < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_endpoints do |t|
      t.string :request_type, default: "get"
      t.string :model
      t.string :action_name
      t.string :on, default: "member"

      t.timestamps
    end
  end
end
