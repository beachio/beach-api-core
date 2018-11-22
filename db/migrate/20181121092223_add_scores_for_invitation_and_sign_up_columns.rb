class AddScoresForInvitationAndSignUpColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :oauth_applications, :scores_for_invite, :integer, default: 0
    add_column :oauth_applications, :scores_for_sign_up, :integer, default: 0
  end
end
