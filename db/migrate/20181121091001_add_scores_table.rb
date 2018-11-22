class AddScoresTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_scores do |t|
      t.references :application
      t.references :user
      t.integer    :scores, default: 0
    end
  end
end
