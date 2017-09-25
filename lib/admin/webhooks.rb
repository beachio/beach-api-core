ActiveAdmin.register BeachApiCore::Webhook, as: 'Webhook' do

  permit_params :kind, :application_id, :uri

  index do
    id_column
    column :kind
    column :uri
    actions
  end

  filter :kind

  show do
    attributes_table do
      row :kind
      row :application
      row :uri
    end
  end
end
