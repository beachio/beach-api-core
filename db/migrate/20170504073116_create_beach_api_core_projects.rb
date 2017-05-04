class CreateBeachApiCoreProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_projects do |t|
      t.string :name
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.references :organisation, foreign_key: { to_table: :beach_api_core_organisations }, null: false

      t.timestamps
    end
  end
end
