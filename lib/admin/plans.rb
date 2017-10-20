ActiveAdmin.register BeachApiCore::Plan, as: 'Plan' do
  menu parent: 'Organisations'

  permit_params :name

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.plan.one')) do
      f.input :name
    end
    f.actions
  end

  show do |_name|
    attributes_table do
      row :name
    end
  end
end
