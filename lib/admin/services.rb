ActiveAdmin.register BeachApiCore::Service, as: 'Service' do
  menu priority: 71, parent: 'Services'

  permit_params :title, :description, :service_category_id, icon_attributes: %i(id file)

  index do
    id_column
    column :title
    column :description
    column :service_category
    actions
  end

  filter :title
  filter :service_category

  form do |f|
    f.object.build_icon if f.object.icon.blank?
    f.inputs t('active_admin.details', model: t('activerecord.models.service.one')) do
      f.input :title
      f.input :description
      f.input :service_category
      li do
        f.label :icon
        f.fields_for :icon do |i|
          span { i.attachment_field :file, direct: true }
        end
        if f.object.icon.file.present?
          div { image_tag attachment_url(f.object.icon, :file, :fill, 150, 150) }
        end
      end
    end
    f.actions
  end

  show do |service|
    attributes_table do
      row :id
      row :title
      row :description
      row :service_category
      if service.icon.present?
        row :icon do
          image_tag attachment_url(service.icon, :file, :fill, 150, 150)
        end
      end
    end
  end
end
