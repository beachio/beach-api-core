ActiveAdmin.register Doorkeeper::Application, as: 'Application' do
  permit_params :name, :redirect_uri, :owner_id, :owner_type, :mail_type_band_color, :file,
                :application_file, :use_default_application_logo, :background_image_file, :use_default_background_image,
                :use_default_logo_image, :mail_type_band_text_color, :scores_for_invite, :scores_for_sign_up,
                :show_application_logo, :show_instance_logo, :provided_text_color, :background_color, :use_default_background_config,
                :invitation_text, :capabilities_attributes => [:service_id, :_destroy, :id],
                :mail_bodies_attributes => [:id, :_destroy, :mail_type, :text_color, :button_color,
                                            :button_text, :body_text, :button_text_color, :greetings_text,
                                            :footer_text, :signature_text],
                :custom_views_attributes => [:id, :_destroy, :view_type, :form_background_color, :input_style, :header_text,
                                             :success_text, :text_color, :success_text_color, :success_background_color,
                                             :button_style, :button_text, :form_radius, :success_form_radius, :error_text_color,
                                             :success_button_first_link, :success_button_first_icon_type, :success_button_second_link,
                                             :success_button_second_icon_type, :success_button_third_link, :success_button_third_icon_type,
                                             :success_button_first_text, :success_button_second_text, :success_button_third_text, :success_button_style,
                                             :success_button_first_available, :success_button_second_available, :success_button_third_available]

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
      f.input :scores_for_sign_up
      f.input :scores_for_invite
      if f.object.new_record?
        f.input :file, as: :file, label: "Image"
      else
        f.input :current_logo_image, label: "Current Mail Logo Image", as: :file, :hint => image_tag(f.object.logo_url, style: 'width: 300px') unless f.object.logo_url.nil? || f.object.logo_url.empty?
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

      checked = f.object.show_application_logo.nil? ? BeachApiCore::Instance.show_application_logo : f.object.show_application_logo
      f.input :show_application_logo, input_html: {checked: checked}
      if f.object.new_record?
        f.input :application_file, as: :file, label: "Application Logo Image"
      else
        f.input :current_application_logo, label: "Current Application Logo Image", as: :file, :hint => image_tag(f.object.application_logo_url, style: 'width: 100px') unless f.object.application_logo_url.nil? || f.object.application_logo_url.empty?
        f.input :application_file, as: :file, label: "Change Application Logo Image"
        f.input :use_default_application_logo, as: :boolean
      end

      f.input :use_default_background_config, as: :boolean

      if f.object.new_record?
        f.input :background_image_file, as: :file, label: "Background Image"
      else
        f.input :current_background_image, label: "Current Background Image", as: :file, :hint => image_tag(f.object.background_image, style: 'width: 100px') unless f.object.background_image.nil? || f.object.background_image.empty?
        f.input :background_image_file, as: :file, label: "Change Background Image"
        f.input :use_default_background_image, as: :boolean
      end
      f.input :background_color, as: :color, input_html: {value: f.object.background_color.nil? || f.object.background_color.empty? ? BeachApiCore::Instance.background_color : f.object.background_color}
      checked = f.object.show_instance_logo.nil? ? BeachApiCore::Instance.show_instance_logo : f.object.show_instance_logo
      f.input :show_instance_logo, input_html: {checked: checked}
      f.input :provided_text_color, as: :color, input_html: {value: f.object.provided_text_color.nil? || f.object.provided_text_color.empty? ? BeachApiCore::Instance.provided_text_color : f.object.provided_text_color}

      f.has_many :custom_views, allow_destroy: true, heading: t('activerecord.models.custom_view.other') do |t|
        t.input :view_type,  input_html: {class: 'application_view_type'}
        t.input :form_background_color, as: :color, input_html: {value: t.object.form_background_color.nil? || t.object.form_background_color.empty? ? BeachApiCore::Instance.form_background_color : t.object.form_background_color}
        t.input :text_color, as: :color, input_html: {value: t.object.text_color.nil? || t.object.text_color.empty? ? BeachApiCore::Instance.text_color : t.object.text_color}
        t.input :error_text_color, as: :color, input_html: {value: t.object.error_text_color.nil? || t.object.error_text_color.empty? ? "#ff0000" : t.object.error_text_color}
        t.input :success_text_color, as: :color, input_html: {value: t.object.success_text_color.nil? || t.object.success_text_color.empty? ? BeachApiCore::Instance.success_text_color : t.object.success_text_color}
        t.input :success_background_color, as: :color, input_html: {value: t.object.success_background_color.nil? || t.object.success_background_color.empty? ? BeachApiCore::Instance.success_background_color : t.object.success_background_color}
        t.input :button_style, input_html: {rows: 4, placeholder: BeachApiCore::Instance.button_style}
        t.input :form_radius, label: "Form Border Radius", input_html: {value: t.object.form_radius.nil? || t.object.form_radius.empty? ? "0px" : t.object.form_radius}
        t.input :success_form_radius, label: "Success Form Border Radius", input_html: {value: t.object.success_form_radius.nil? || t.object.success_form_radius.empty? ? BeachApiCore::Instance.invitation_success_form_radius : t.object.success_form_radius}
        t.input :input_style, input_html: {rows: 4, placeholder: BeachApiCore::Instance.input_style}
        t.input :header_text, input_html: {rows: 4}
        t.input :success_text, input_html: {rows: 4}
        t.input :success_button_style, input_html: {rows: 4, class: "success_invite_btn"}
        t.input :success_button_first_available, input_html: {class: "button_available"}
        t.input :success_button_first_link, input_html: { class: "success_invite_btn"}
        t.input :success_button_first_icon_type, input_html: { class: "success_invite_btn"}
        t.input :success_button_first_text, input_html: { class: "success_invite_btn"}
        t.input :success_button_second_available, input_html: {class: "button_available"}
        t.input :success_button_second_link, input_html: { class: "success_invite_btn"}
        t.input :success_button_second_icon_type, input_html: { class: "success_invite_btn"}
        t.input :success_button_second_text, input_html: { class: "success_invite_btn"}
        t.input :success_button_third_available, input_html: {class: "button_available"}
        t.input :success_button_third_link, input_html: { class: "success_invite_btn"}
        t.input :success_button_third_icon_type, input_html: { class: "success_invite_btn"}
        t.input :success_button_third_text, input_html: { class: "success_invite_btn"}
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
      row :scores_for_invite
      row :scores_for_sign_up
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
