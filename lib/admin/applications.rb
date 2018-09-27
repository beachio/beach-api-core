ActiveAdmin.register Doorkeeper::Application, as: 'Application' do
  permit_params :name, :redirect_uri, :owner_id, :owner_type, :mail_type_band_color, :file,
                :use_default_logo_image, :mail_type_band_text_color,
                :invitation_text, :capabilities_attributes => [:service_id, :_destroy, :id],
                :mail_bodies_attributes => [:id, :_destroy, :mail_type, :text_color, :button_color,
                                            :button_text, :body_text, :button_text_color, :greetings_text,
                                            :footer_text, :signature_text]

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
      if f.object.new_record?
        f.input :file, as: :file, label: "Image"
      else
        f.input :current_logo_image, label: "Current Logo Image", as: :file, :hint => image_tag(f.object.logo_url, style: 'width: 300px') unless f.object.logo_url.nil? || f.object.logo_url.empty?
        f.input :file, as: :file, label: "New Image"
        f.input :use_default_logo_image, as: :boolean
      end
      if f.object.new_record?
        f.input :mail_type_band_color, as: :color, input_html: {value: '#ff8000'}
      else
        f.input :mail_type_band_color, as: :color
      end
      if f.object.new_record?
        f.input :mail_type_band_text_color, as: :color, input_html: {value: '#FFFFFF'}
      else
        f.input :mail_type_band_text_color, as: :color
      end

      f.has_many :mail_bodies, allow_destroy: true, heading: t('activerecord.models.mail_body.other') do |t|
        t.input :mail_type, input_html: {class: 'application_mail_type'}
        if t.object.new_record?
          t.input :text_color, as: :color, input_html: {value: "#000000"}
        else
          t.input :text_color, as: :color
        end
        if t.object.new_record?
          t.input :button_color, as: :color, input_html: {value: "#3FD485"}
        else
          t.input :button_color, as: :color
        end
        if t.object.new_record?
          t.input :button_text_color, as: :color, input_html: {value: "#376E50"}
        else
          t.input :button_text_color, as: :color
        end
        t.input :greetings_text, input_html: {class: "mail_config_text"}
        t.input :body_text, input_html: {class: "mail_config_text"}
        t.input :button_text, input_html: {class: "mail_config_text"}
        t.input :signature_text, input_html: {rows: 3, class: "mail_config_text"}
        t.input :footer_text, input_html: {class: "mail_config_text"}
      end
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
      unless app.logo_url.nil? || app.logo_url.empty?
        row :current_mail_logo do |logo|
          link_to(logo.logo_url, logo.logo_url)
        end
      end
    end
  end
end
