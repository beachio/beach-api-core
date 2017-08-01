ActiveAdmin.register BeachApiCore::Capability, as: 'Capability' do
  menu priority: 73, parent: 'Services'

  permit_params :service_id, :application_id

  index do
    id_column
    column :service
    column :application
    actions
  end

  filter :service
  filter :application

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.service.one')) do
      f.input :application
      f.input :service
    end
    f.actions
  end

  show do |_capability|
    attributes_table do
      row :application
      row :service
    end
  end
end
