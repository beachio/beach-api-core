class RemoveScoresFromUser < ActiveRecord::Migration[5.1]
  def up
    remove_column :beach_api_core_users, :scores
  end

  def down
    add_column :beach_api_core_users, :scores, :integer, default: 0
  end
end
