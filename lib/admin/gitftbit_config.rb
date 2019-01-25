ActiveAdmin.register BeachApiCore::GiftbitConfig, as: 'GiftbitConfigs' do
  menu priority: 67, parent: 'Achievements and Rewards'
  permit_params :application_id, :giftbit_token, :config_name, :email_to_notify,
                :giftbit_brands_attributes => [:_destroy, :id, :brand_code,
                                                :amount, :giftbit_email_template,
                                                :email_subject, :email_body, :gift_name
                                               ]

  form do |f|
    f.inputs "Giftbit Config Details" do
      f.semantic_errors *f.object.errors.keys
      f.input :application
      f.input :config_name
      f.input :giftbit_token
      f.input :email_to_notify
      brands = giftbit_brand_list(true)
      f.has_many :giftbit_brands, allow_destroy: true do |t|
        t.input :brand_code, collection: brands
        t.input :gift_name
        t.input :amount
        t.input :giftbit_email_template
        t.input :email_subject
        t.input :email_body
      end
    end
    f.actions
  end

  show do |config|
    attributes_table do
      row :id
      row :application
      row :config_name
      row :email_to_notify
    end
    panel "Brands Configs" do
      table_for config.giftbit_brands do
        column :id
        column :gift_name
        column :brand_code
        column :amount
      end
    end
  end

  index do
    id_column
    column :application
    column :config_name
    actions
  end
end
