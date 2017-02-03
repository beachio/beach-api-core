class CreateBeachApiCoreInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :beach_api_core_invitations do |t|
      t.string :email
      t.references :user
      t.references :group, polymorphic: true
      t.timestamps
    end
  end
end
