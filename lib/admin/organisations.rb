ActiveAdmin.register BeachApiCore::Organisation, as: 'Organisation' do
  menu parent: 'Organisations'

  permit_params :name, :application_id, :send_email,
                logo_image_attributes: %i(id file),
                organisation_plan_attributes: %i(plan_id)

  index do
    id_column
    column :name
    column :send_email
    actions
  end

  filter :name
  filter :application

  form do |f|
    f.object.build_logo_image if f.object.logo_image.blank?
    f.object.build_organisation_plan if f.object.organisation_plan.blank?
    f.inputs t('active_admin.details', model: t('activerecord.models.organisation.one')) do
      f.input :name
      f.input :application, as: :select, collection: Doorkeeper::Application.all
      li do
        f.label :logo
        f.fields_for :logo_image do |l|
          span { l.attachment_field :file, direct: true }
        end
        if f.object.logo_image.file.present?
          div { image_tag attachment_url(f.object.logo_image, :file, :fill, 150, 150) }
        end
      end
      f.fields_for :organisation_plan do |p|
        p.input :plan, as: :select, collection: BeachApiCore::Plan.all
      end
      f.input :send_email
    end
    f.actions
  end

  show do |organisation|
    attributes_table do
      row :name
      row :application
      if organisation.logo_image.present?
        row :logo do
          image_tag attachment_url(organisation.logo_image, :file, :fill, 150, 150)
        end
      end
      if organisation.plan.present?
        row :plan
      end
      row :send_email
    end
  end
end
