ActiveAdmin.register BeachApiCore::Team, as: 'Team' do
  menu priority: 50

  permit_params :name, :application_id

  index do
    id_column
    column :name
    actions
  end

  filter :name

  form do |f|
    f.inputs t('active_admin.details', model: t('activerecord.models.team.one')) do
      f.input :name
      f.input :application, as: :select, collection: Doorkeeper::Application.all
    end
    f.actions
  end

  show do |team|
    attributes_table do
      row :name
      row :application
      row :owners do
        safe_join(team.owners.map do |owner|
          link_to owner.username, admin_user_path(owner)
        end, ', ')
      end
    end
  end
end
