class AddOrganisationIdToOauthAccessTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :oauth_access_tokens, :organisation_id, :integer
  end
end
