ActiveAdmin.register Doorkeeper::Application, as: 'Application' do
  permit_params :name, :redirect_uri, :owner_id, :owner_type, :capabilities_attributes => [:service_id, :_destroy, :id]

  index do
    id_column
    column :name
    actions
  end

  action_item only: :index do
    link_to 'Run task to add services and capabilities', add_services_and_applications_admin_applications_path
  end

  collection_action :add_services_and_applications, method: :get do
    BeachApiCore::ApplicationServiceHelper.add_capabilities_to_applications
    redirect_to admin_applications_path
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.application.one')) do
      f.input :name
      f.input :redirect_uri, required: true
      f.input :owner, as: :select,
                      collection: BeachApiCore::Instance.current.developers + BeachApiCore::Instance.current.admins
      f.input :owner_type, as: :hidden, input_html: { value: 'BeachApiCore::User' }
      f.has_many :capabilities, allow_destroy: true, heading: t('activerecord.models.service.other') do |t|
        t.input :service, as: :select, collection: BeachApiCore::Service.all.pluck(:title, :id), label: t('activerecord.models.service.one')
      end
    end
    f.actions
  end

  show do |app|
    attributes_table do
      row :name
      row :redirect_uri
      row :uid
      row :secret
      if app.capabilities.any?
        row :service do
          safe_join(app.capabilities.map do |capability|
            link_to capability.service.title, admin_service_path(capability.service)
          end, ', ')
        end
      end
    end
  end
end
