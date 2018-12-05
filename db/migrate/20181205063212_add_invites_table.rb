class AddInvitesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_invites do |t|
      t.references :application
      t.references :user
      t.integer    :quantity
    end

    add_column :oauth_applications, :invite_limit, :integer, default: 0
  end
end
