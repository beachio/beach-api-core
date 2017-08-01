ActiveAdmin.register BeachApiCore::Role, as: 'Role' do
  menu priority: 20, parent: 'Permissions'

  permit_params :name

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.role.one')) do
      f.input :name
    end
    f.actions
  end

  show do |_role|
    attributes_table do
      row :name
    end
  end
end
