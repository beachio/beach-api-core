class AddResetPasswordTokenToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :beach_api_core_users, :reset_password_token, :string
  end

  def down
    remove_column :beach_api_core_users, :reset_password_token
  end
end
