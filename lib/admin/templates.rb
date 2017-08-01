ActiveAdmin.register BeachApiCore::Template, as: 'Template' do
  menu priority: 50
  permit_params :name, :value, :kind

  index do
    id_column
    column :name
    column :value
    tag_column :kind
    actions
  end

  filter :name
  filter :value
  filter :kind

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.template.one')), class: 'inputs' do
      f.input :name
      f.input :value
      f.input :kind
    end
    f.actions
  end

  show do |_template|
    attributes_table do
      row :name
      row :value
      tag_row :kind
    end
  end
end
