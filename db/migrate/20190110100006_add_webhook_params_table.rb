class AddWebhookParamsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_webhook_parametrs do |t|
      t.references :webhook_config
      t.string :name
      t.string :value
    end
  end
end
