ActiveAdmin.register BeachApiCore::Bot, as: 'Bots' do
  menu priority: 101

  permit_params do
    [:name, :application_id, :flow_id, :dialog_flow_client_access_token, avatar_attributes: %i(id file)]
  end

  index do
    id_column
    column :name
    column :application_name do |bot|
      bot.application&.name
    end
    actions
  end

  filter :name

  form do |f|
    f.object.build_avatar unless f.object.avatar

    f.inputs t('active_admin.details', model: t('activerecord.models.bot.one')) do
      f.input :application_id, as: :select, collection: current_user.applications.all
      f.input :name
      if f.object&.available_flows&.any?
        f.input :flow_id, as: :select, collection: f.object.available_flows
      end

      li do
        f.label :avatar
        f.fields_for :avatar do |a|
          span { a.attachment_field :file, direct: true }
        end
      end

      if f.object.avatar.file.present?
        li do
          render html: "<label>&nbsp;</label>".html_safe
          div { image_tag attachment_url(f.object.avatar, :file, :fill, 150, 150) }
        end
      end

      f.input :dialog_flow_client_access_token
    end
    f.actions
  end

  show do |bot|
    attributes_table do
      row :uuid
      row :name
      row :application_name do
        bot.application&.name
      end
      if bot.flow
        row :active_flow do
          link_to bot.flow&.name, "/admin/flows/#{bot.flow.id}/edit"
        end
      end
      row :flows do
        div do
          link_to "Edit flows", "/admin/flows?bot_uuid=#{bot.uuid}", style: "padding: 8px 15px; background: #2984a3; color: white; text-decoration: none; margin: 5px 0; display: inline-block;"
        end
      end
      div do
        open_in_mobile(bot)
      end
    end
  end
end
