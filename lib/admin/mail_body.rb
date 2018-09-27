ActiveAdmin.register BeachApiCore::MailBody, as: 'MailBody' do
  menu priority: 66, parent: 'Mails'

  permit_params :mail_type, :application_id,  :text_color, :button_color, :button_text, :body_text,
                :button_text_colour, :greetings_text, :signature_text, :footer_text

  index do
    id_column
    column :application
    column :mail_type
    actions
  end

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.mail_body.one')) do
      f.input :application
      f.input :mail_type
      if f.object.new_record?
        f.input :text_color, as: :color, input_html: {value: "#000000"}
      else
        f.input :text_color, as: :color
      end
      if f.object.new_record?
        f.input :button_color, as: :color, input_html: {value: "#3FD485"}
      else
        f.input :button_color, as: :color
      end
      if f.object.new_record?
        f.input :button_text_color, as: :color, input_html: {value: "#376E50"}
      else
        f.input :button_text_color, as: :color
      end
      f.input :greetings_text, input_html: {class: "mail_config_text"}
      f.input :body_text, input_html: {class: "mail_config_text"}
      f.input :button_text, input_html: {class: "mail_config_text"}
      f.input :signature_text, input_html: {rows: 3, class: "mail_config_text"}
      f.input :footer_text, input_html: {class: "mail_config_text"}
    end
    f.actions
  end
end