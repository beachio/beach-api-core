class AddInviteeToBeachApiCoreInvitations < ActiveRecord::Migration[5.0]
  def change
    add_reference :beach_api_core_invitations, :invitee, foreign_key: { to_table: :beach_api_core_users }
  end
end
