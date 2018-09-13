class AddParamsToWebhooks < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_webhooks, :parametrs, :text, :default => "{}"
  end
end
