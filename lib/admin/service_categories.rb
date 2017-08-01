ActiveAdmin.register BeachApiCore::ServiceCategory, as: 'ServiceCategory' do
  menu priority: 67, parent: 'Services'

  permit_params :name

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.service_category.one')) do
      f.input :name
    end
    f.actions
  end

  show do |_service_category|
    attributes_table do
      row :name
    end
  end
end
