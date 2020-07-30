class CreateBeachApiCoreActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_activities do |t|
      t.string :kind
      t.references :user, foreign_key: { to_table: :beach_api_core_users }
      t.references :affected, polymorphic: true
      t.references :origin, polymorphic: true
      t.references :destination, polymorphic: true


      t.timestamps
    end
  end
end
