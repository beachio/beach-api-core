class AddGiftbitConfigTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_giftbit_configs do |t|
      t.references :application
      t.string :giftbit_token
      t.string :config_name
    end
  end
end
