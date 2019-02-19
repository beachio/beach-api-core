class AddEmailForNotifyToGiftbitConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_giftbit_configs, :email_to_notify, :string
  end
end
