class AddBeachRewardTable < ActiveRecord::Migration[5.1]
  def change
    create_table :beach_api_core_rewards do |t|
      t.references :achievement
      t.references :reward_to, polymorphic: true, index: true
      t.boolean    :confirmed, :default => false
      t.string     :gift_uuid
      t.string     :campaign_uuid
      t.string     :shortlink
      t.integer    :status, default: 0
      t.references :giftbit_brand
      t.timestamps
    end
  end
end
