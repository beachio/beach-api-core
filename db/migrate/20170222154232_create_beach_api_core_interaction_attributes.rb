class CreateBeachApiCoreInteractionAttributes < ActiveRecord::Migration[5.1]
  def change
    enable_extension "hstore"
    create_table :beach_api_core_interaction_attributes do |t|
      t.references :interaction, foreign_key: { to_table: :beach_api_core_interactions }
      t.string :key, null: false
      t.hstore :values, default: {}

      t.timestamps
    end
  end
end
