class AddApplicationColumnToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_subscriptions, :application
  end
end
