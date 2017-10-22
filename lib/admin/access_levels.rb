ActiveAdmin.register BeachApiCore::AccessLevel, as: 'AccessLevel' do
  menu parent: 'Permissions', priority: 53, label: I18n.t('activerecord.models.access_level.other')
  permit_params :title

  index do
    id_column
    column :title
    actions
  end

  filter :title

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.access_level.one')) do
      f.input :title
    end
    f.actions
  end

  show do |_access_level|
    attributes_table do
      row :id
      row :title
    end
  end
end
