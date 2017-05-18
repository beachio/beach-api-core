class CreateBeachApiCoreTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_teams do |t|
      t.string :name
      t.references :application
      t.timestamps
    end
  end
end
