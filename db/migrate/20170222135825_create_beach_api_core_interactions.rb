class CreateBeachApiCoreInteractions < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_interactions do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }
      t.references :keeper, polymorphic: true, index: true
      t.string :kind, null: false
      t.timestamps
    end
  end
end
