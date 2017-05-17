class RemoveRoleIdFromInvitations < ActiveRecord::Migration[5.1]
  def up
    create_table :beach_api_core_invitation_roles do |t|
      t.references :role, null: false
      t.references :invitation, null: false
      t.timestamps
    end

    BeachApiCore::Invitation.find_each do |invitation|
      BeachApiCore::InvitationRole.create(invitation: invitation, role: BeachApiCore::Role.find(invitation.role_id))
    end

    remove_column :beach_api_core_invitations, :role_id
  end

  def down
    add_column :beach_api_core_invitations, :role_id, :integer

    BeachApiCore::Invitation.find_each do |invitation|
      invitation.update(role_id: invitation.roles.first.id)
    end

    drop_table :beach_api_core_invitation_roles
  end
end
