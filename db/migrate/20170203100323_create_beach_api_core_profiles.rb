class CreateBeachApiCoreProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_profiles do |t|
      t.string :first_name
      t.string :last_name
      t.date   :birth_date
      t.integer :sex
      t.string :time_zone
      t.references :user
      t.timestamps
    end
  end
end
