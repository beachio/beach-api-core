class AddKeepersColumnsToWebhook < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_webhooks, :keeper, polymorphic: true, index: true
  end
end
