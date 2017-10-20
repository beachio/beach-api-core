class CreateBeachApiCorePlanItems < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_plan_items do |t|
      t.references :plan
      t.references :access_level
      t.integer :users_count

      t.timestamps
    end
  end
end
