ActiveAdmin.register  BeachApiCore::Invite, as: 'InvitesCount' do
  menu priority: 52, parent: 'Users'

  permit_params :quantity, :application_id, :user_id

  action_item only: :show do
    link_to 'Reset invites count', reset_invites_count_admin_invites_count_path
  end

  member_action :reset_invites_count, method: :get do
    invite = BeachApiCore::Invite.find_by(id: params[:id])
    invite.reset_invites_count
    redirect_to admin_invites_counts_path
  end

  index do
    id_column
    column :user
    column :application
    column :quantity
    actions
  end

  filter :name

  form do |f|
    f.inputs "Invites Count Details" do
      f.input :user, collection: BeachApiCore::User.all.map {|user| ["#{user.username} - #{user.email}", user.id]}
      f.input :application
      f.input :quantity
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :application
      row :user
      row :quantity
    end
  end
end
