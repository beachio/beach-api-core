class AddInviteeRoleTokenToBeachApiCoreInvitations < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_invitations, :invitee, foreign_key: { to_table: :beach_api_core_users }
    add_reference :beach_api_core_invitations, :role, foreign_key: { to_table: :beach_api_core_roles }
    add_column :beach_api_core_invitations, :token, :string, null: false, default: ''
  end
end
