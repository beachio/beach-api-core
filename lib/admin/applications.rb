ActiveAdmin.register Doorkeeper::Application, as: 'Application' do
  permit_params :name, :redirect_uri, :owner_id, :owner_type

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.application.one')) do
      f.input :name
      f.input :redirect_uri, required: true
      f.input :owner, as: :select,
              collection: BeachApiCore::Instance.current.developers + BeachApiCore::Instance.current.admins
      f.input :owner_type, as: :hidden, input_html: { value: 'BeachApiCore::User' }
    end
    f.actions
  end

  show do |_app|
    attributes_table do
      row :name
      row :redirect_uri
      row :uid
      row :secret
    end
  end
end
