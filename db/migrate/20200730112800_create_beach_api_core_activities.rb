class CreateBeachApiCoreActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_activities do |t|
      t.integer :kind, null: false
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.references :affected, polymorphic: true, index: { name: 'index_activities_on_affected_type_and_affected_id' }
      t.references :origin, polymorphic: true
      t.references :destination, polymorphic: true, index: { name: 'index_activities_on_destination_type_and_destination_id' }

      t.timestamps
    end
  end
end
