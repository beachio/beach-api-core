class CreateBeachApiCoreEntities < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_entities do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.string :uid, null: false
      t.string :kind, null: false
      t.hstore :settings, default: {}

      t.timestamps
    end
    add_index :beach_api_core_entities, %i(uid kind), unique: true, name: 'index_entities_on_uid_and_kind'
  end
end
