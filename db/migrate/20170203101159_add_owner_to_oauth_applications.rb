class AddOwnerToOauthApplications < ActiveRecord::Migration[5.0]
  def change
    add_reference :oauth_applications, :owner, index: true, polymorphic: true
  end
end
