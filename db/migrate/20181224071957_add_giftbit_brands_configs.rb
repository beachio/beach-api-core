class AddGiftbitBrandsConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_giftbit_brands do |t|
      t.references :giftbit_config
      t.string :gift_name
      t.integer :amount
      t.string :brand_code
      t.string :giftbit_email_template
      t.string :email_subject
      t.text :email_body
    end
  end
end
