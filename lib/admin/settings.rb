ActiveAdmin.register BeachApiCore::Setting, as: 'Setting' do
  permit_params :name, :value, :keeper_type, :keeper_id

  config.filters = false

  index do
    id_column
    column :name
    column :value
    column :keeper do |field|
      keeper_name(field.keeper)
    end
    actions
  end

  form do |f|
    f.inputs t('active_admin.details',
               model: t('activerecord.models.setting.one')),
             class: 'inputs js-keepers js-keeper_wrapper' do
      f.input :keeper_type, as: :hidden, input_html: { class: 'js-keeper_type' }
      f.input :keeper_id, as: :hidden, input_html: { class: 'js-keeper_id' }
      f.input :name
      f.input :value
      f.input :keeper, as: :select,
                       collection: options_for_select(keepers, "#{f.object.keeper_type}##{f.object.keeper_id}"),
                       input_html: { class: 'js-keeper_select', name: :keeper }
    end
    f.actions
  end

  show do |setting|
    attributes_table do
      row :id
      row :name
      row :value
      row :keeper do
        keeper_name(setting.keeper)
      end
    end
  end
end
