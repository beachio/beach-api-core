class CreateBeachApiCoreUserAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_user_accesses do |t|
      t.references :access_level
      t.references :user
      t.references :keeper, polymorphic: true, index: true

      t.timestamps
    end
  end
end
