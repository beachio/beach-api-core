class AddWebhookConfigTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_webhook_configs do |t|
      t.references :application
      t.string :uri
      t.integer :request_method, default: 0
      t.text :request_body
      t.string :config_name
    end
  end
end
