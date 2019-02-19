class AddBeachAchievementsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_achievements do |t|
      t.references :application
      t.string :achievement_name
      t.integer :points_required
      t.integer :max_rewards
      t.integer :reward_expiry, default: 0
      t.boolean :reward_issue_requires_approval, default: false
      t.boolean :notify_by_email, default: false
      t.references :mode, polymorphic: true, index: true
      t.boolean :notify_via_broadcasts, default: false
      t.integer :available_for, default: 0
      t.references :giftbit_config
    end

    create_table :beach_api_core_achievement_brands do |t|
      t.belongs_to :achievement
      t.belongs_to :giftbit_brand
    end
  end
end
