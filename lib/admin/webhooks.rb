ActiveAdmin.register BeachApiCore::Webhook, as: 'Webhook' do
  permit_params :kind, :uri, :keeper_id, :keeper_type, :scores

  index do
    id_column
    column :kind
    column :uri
    column :keeper do |field|
      keeper_name(field.keeper)
    end
    actions
  end

  filter :kind

  show do |webhook|
    attributes_table do
      row :kind
      row :uri
      row :keeper do
        keeper_name(webhook.keeper)
      end
      row :scores do
        webhook.parametrs.gsub(/{\S*\s*/, "").gsub("}", "")
      end if webhook.kind == 'scores_achieved'
    end
  end

  form do |f|
    f.inputs "Details", class: 'inputs js-keepers js-keeper_wrapper' do
      f.input :kind
      f.input :keeper_type, as: :hidden, input_html: { class: 'js-keeper_type' }
      f.input :keeper_id, as: :hidden, input_html: { class: 'js-keeper_id' }
      f.input :keeper, as: :select,
              collection: options_for_select(webhooks_keeper, "#{f.object.keeper_type}##{f.object.keeper_id}"),
              input_html: { class: 'js-keeper_select', name: :keeper }
      if f.object.new_record?
        f.input :scores, as: :number
      else
        val = f.object.parametrs.gsub(/{\S*\s*/, "").gsub("}", "") if f.object.kind == 'scores_achieved'
        f.input :scores, as: :number, :input_html => { :value => val }
      end
      f.input :uri
    end
    f.actions
  end
end
