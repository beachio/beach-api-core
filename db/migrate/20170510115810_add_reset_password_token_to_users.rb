class AddResetPasswordTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :beach_api_core_users, :reset_password_token, :string
  end
end
