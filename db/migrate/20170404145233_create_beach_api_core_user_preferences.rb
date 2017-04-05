class CreateBeachApiCoreUserPreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_user_preferences do |t|
      t.references :user
      t.references :application
      t.hstore :preferences, default: {}
    end
  end
end
