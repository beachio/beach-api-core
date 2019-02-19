ActiveAdmin.register BeachApiCore::WebhookConfig, as: 'WebhookConfigs' do
  menu priority: 68, parent: 'Achievements and Rewards'
  permit_params :config_name, :application_id, :request_method, :request_body, :uri, :webhook_parametrs_attributes => [:_destroy, :id, :name, :value]


  form do |f|
    f.inputs "Details" do
      f.input :config_name
      if f.object.new_record?
        f.input :application
      else
        f.input :application, input_html: {disabled: true}
      end
      f.input :uri
      f.input :request_method
      f.input :request_body, input_html: {rows: 4}
      f.has_many :webhook_parametrs, heading: t('activerecord.models.beach_api_core/webhook_parametr.other') do |t|
        t.input :name
        t.input :value
      end
    end
    f.actions
  end

  show do |webhook_config|
    attributes_table do
      row :config_name
      row :application
      row :request_method
      row :request_body
      row :uri
    end

    panel "Params" do
      table_for webhook_config.webhook_parametrs do |param|
        column :id
        column :name
        column :value
      end
    end
  end

  index do
    id_column
    column :application
    column :config_name
    column :uri
    column :request_method
    actions
  end

end

