class CreateBeachApiCoreProjectKeepers < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_project_keepers do |t|
      t.references :project, foreign_key: { to_table: :beach_api_core_projects }, null: false
      t.references :keeper, polymorphic: true, null: false,
                   index: { name: 'index_beach_api_core_project_keepers_on_k_type_and_k_id' }

      t.timestamps
    end
  end
end
