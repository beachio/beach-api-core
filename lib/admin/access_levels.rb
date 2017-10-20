ActiveAdmin.register BeachApiCore::AccessLevel, as: 'AccessLevel' do
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

  show do |_atom|
    attributes_table do
      row :id
      row :title
    end
  end
end
