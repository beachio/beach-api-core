class CreateBeachApiCoreInvitationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_invitation_tokens do |t|
      t.references :user, foreign_key: { to_table: :beach_api_core_users }, null: false
      t.references :entity, polymorphic: true,
                            index: { name: :index_beach_api_core_i_tokens_on_entity_type_and_entity_id }
      t.string :token, unique: true, index: true, null: false
      t.datetime :expire_at
      t.timestamps
    end
  end
end
