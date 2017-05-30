class CreateBeachApiCoreWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_webhooks do |t|
      t.string :uri, null: false
      t.integer :kind, null: false
      t.references :application, foreign_key: { to_table: :oauth_applications }

      t.timestamps
    end
  end
end
