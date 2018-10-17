ActiveAdmin.register BeachApiCore::CustomView, as: 'CustomView' do
  menu priority: 66, parent: 'Custom Configs'

  permit_params :view_type, :application_id,  :input_style, :header_text, :form_background_color, :success_text,
                :text_color, :success_text_color, :success_background_color, :button_style, :button_text,
                :form_radius, :success_form_radius, :error_text_color,:success_button_first_link, :success_button_first_icon_type, :success_button_second_link,
                :success_button_second_icon_type, :success_button_third_link, :success_button_third_icon_type,
                :success_button_first_text, :success_button_second_text, :success_button_third_text, :success_button_style,
                :success_button_first_available, :success_button_second_available, :success_button_third_available

  index do
    id_column
    column :application
    column :view_type
    actions
  end

  form do |f|
    f.inputs t('active_admin.details', model: 'Custom View') do
      f.input :application
      f.input :view_type
      f.input :form_background_color, as: :color, input_html: {value: f.object.form_background_color.nil? || f.object.form_background_color.empty? ? BeachApiCore::Instance.form_background_color : f.object.form_background_color}
      f.input :text_color, as: :color, input_html: {value: f.object.text_color.nil? || f.object.text_color.empty? ? BeachApiCore::Instance.text_color : f.object.text_color}
      f.input :error_text_color, as: :color, input_html: {value: f.object.error_text_color.nil? || f.object.error_text_color.empty? ? "#ff0000" : f.object.error_text_color}
      f.input :success_text_color, as: :color, input_html: {value: f.object.success_text_color.nil? || f.object.success_text_color.empty? ? BeachApiCore::Instance.success_text_color : f.object.success_text_color}
      f.input :success_background_color, as: :color, input_html: {value: f.object.success_background_color.nil? || f.object.success_background_color.empty? ? BeachApiCore::Instance.success_background_color : f.object.success_background_color}
      f.input :button_style, input_html: {rows: 4, placeholder: BeachApiCore::Instance.button_style}
      f.input :form_radius, label: "Form Border Radius", input_html: {value: f.object.form_radius.nil? || f.object.form_radius.empty? ? "0px" : f.object.form_radius}
      f.input :success_form_radius, label: "Success Form Border Radius", input_html: {value: f.object.success_form_radius.nil? || f.object.success_form_radius.empty? ? BeachApiCore::Instance.invitation_success_form_radius : f.object.success_form_radius}
      f.input :input_style, input_html: {rows: 4, placeholder: BeachApiCore::Instance.input_style}
      f.input :header_text, input_html: {rows: 4}
      f.input :success_text, input_html: {rows: 4}
      f.input :success_button_style, input_html: {rows: 4, class: "success_invite_btn"}
      f.input :success_button_first_available, input_html: {class: "custom_button_available"}
      f.input :success_button_first_link, input_html: { class: "success_invite_btn"}
      f.input :success_button_first_icon_type, input_html: { class: "success_invite_btn"}
      f.input :success_button_first_text, input_html: { class: "success_invite_btn"}
      f.input :success_button_second_available, input_html: {class: "custom_button_available"}
      f.input :success_button_second_link, input_html: { class: "success_invite_btn"}
      f.input :success_button_second_icon_type, input_html: { class: "success_invite_btn"}
      f.input :success_button_second_text, input_html: { class: "success_invite_btn"}
      f.input :success_button_third_available, input_html: {class: "custom_button_available"}
      f.input :success_button_third_link, input_html: { class: "success_invite_btn"}
      f.input :success_button_third_icon_type, input_html: { class: "success_invite_btn"}
      f.input :success_button_third_text, input_html: { class: "success_invite_btn"}
    end
    f.actions
  end
end