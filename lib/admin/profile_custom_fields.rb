ActiveAdmin.register BeachApiCore::ProfileCustomField, as: 'UserProfileCustomField' do
  menu parent: 'Users', priority: 52, label: I18n.t('activerecord.models.profile_custom_field.other')

  # @todo: investigate an ability to move from `permitted_params` method to AA `permit_params`
  permit_params :title, :keeper_id, :keeper_type, :name

  index do
    id_column
    column :title
    column :keeper do |field|
      keeper_name(field.keeper)
    end
    column :status
    actions
  end

  filter :title
  form do |f|
    f.inputs t('active_admin.details', model: t('admin.inputs.field')), class: 'inputs js-keepers js-keeper_wrapper' do
      f.input :keeper_type, as: :hidden, input_html: { class: 'js-keeper_type' }
      f.input :keeper_id, as: :hidden, input_html: { class: 'js-keeper_id' }
      f.input :title
      f.input :keeper, as: :select,
              collection: options_for_select(keepers, "#{f.object.keeper_type}##{f.object.keeper_id}"),
              input_html: { class: 'js-keeper_select', name: :keeper }
      f.input :status, as: :select, collection: BeachApiCore::ProfileCustomField.statuses.keys, include_blank: false
    end
    f.actions
  end


  show do |field|
    attributes_table do
      row :id
      row :title
      row :keeper do
        keeper_name(field.keeper)
      end
      row :status
    end
  end

end
