class AddScoresColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :beach_api_core_users, :scores, :integer, :default => 0
  end
end
