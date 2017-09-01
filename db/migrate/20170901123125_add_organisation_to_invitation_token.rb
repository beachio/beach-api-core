class AddOrganisationToInvitationToken < ActiveRecord::Migration[5.1]
  def change
    add_reference :beach_api_core_invitation_tokens, :organisation,
                  foreign_key: { to_table: :beach_api_core_organisations }
  end
end
