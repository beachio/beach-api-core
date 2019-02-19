module AchievementDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/achievements', 'Create new achievement'
  header 'Authorization', 'Bearer access_token', required: true
  param :achievement, Hash, required: true do
    param :achievement_name,     String, required: true
    param :points_required,      Integer, required: true
    param :max_rewards,          String, required: true, desc: "Should be one of '1 per day', '1 per week', '1 per month', 'unlimited'"
    param :available_for,          String, required: true, desc: "Should be one of 'users', 'devices', 'users and devices'"
    param :reward_expiry,        Integer, required: false
    param :reward_issue_requires_approval, [true, false], required: false
    param :notify_by_email, [true, false], required: false
    param :notify_via_broadcasts, [true, false], required: false
    param :mode_type, String, required: true, desc: "Should be one of 'GiftbitConfig', 'WebhookConfig'"
    param :mode_id, Integer, required: true, desc: "config id"
    param :giftbit_brand_ids, Array, required: false, desc: "Can be used only for GiftbitConfig and can have ids of brands for this config"
    param :use_all_config_brands, [true, false], required: false, desc: "Can be used only for GiftbitConfig."
  end
  example '
  {
    "achievement": {
      "id": 15,
      "achievement_name": "test_app_giftbit_api",
      "points_required": 120,
      "max_rewards": "1 per month",
      "available_for": "users",
      "reward_expiry": 0,
      "reward_issue_requires_approval": false,
      "notify_by_email": false,
      "mode_type": "GiftbitConfig",
      "mode_id": 4,
      "notify_via_broadcasts": true,
      "reward_can_be_claimed": false,
      "achievement_brands": [
        {
          "id": 7,
          "giftbit_config_id": 4,
          "gift_name": "$12 playstation Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Playstation_template_id",
          "email_subject": "",
          "email_body": ""
        }
      ]
    }
  }'
  def create; end

  api :GET, '/achievements', 'Return all application\'s achievements'
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "achievements": [
      {
        "id": 12,
        "achievement_name": "test_names",
        "points_required": 234,
        "max_rewards": "unlimited",
        "available_for": "users",
        "reward_expiry": 0,
        "reward_issue_requires_approval": false,
        "notify_by_email": false,
        "mode_type": "WebhookConfig",
        "mode_id": 2,
        "notify_via_broadcasts": false,
        "reward_can_be_claimed": true
      },
      {
        "id": 13,
        "achievement_name": "test_app_giftbit",
        "points_required": 120,
        "max_rewards": "1 per month",
        "available_for": "users",
        "reward_expiry": 0,
        "reward_issue_requires_approval": false,
        "notify_by_email": false,
        "mode_type": "GiftbitConfig",
        "mode_id": 4,
        "notify_via_broadcasts": true,
        "reward_can_be_claimed": true,
        "achievement_brands": [
          {
            "id": 7,
            "giftbit_config_id": 4,
            "gift_name": "$12 playstation Gift Card",
            "amount": 500,
            "brand_code": "walmart",
            "giftbit_email_template": "Playstation_template_id",
            "email_subject": "",
            "email_body": ""
          }
        ]
      }
    ]
  }'
  def index; end

  api :GET, '/achievements/:id', 'Return achievement data'
  header 'Authorization', 'Bearer access_token', required: true
  example '
    {
    "achievement": {
      "id": 13,
      "achievement_name": "test_app_giftbit",
      "points_required": 120,
      "max_rewards": "1 per month",
      "available_for": "users",
      "reward_expiry": 0,
      "reward_issue_requires_approval": false,
      "notify_by_email": false,
      "notify_via_broadcasts": true,
      "reward_can_be_claimed": true,
      "achievement_brands": [
        {
          "id": 7,
          "giftbit_config_id": 4,
          "gift_name": "$12 playstation Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Playstation_template_id",
          "email_subject": "",
          "email_body": ""
        }
      ]
    }
  }'
  def show; end

  api :PUT, '/achievements/:id', 'Update achievement'
  header 'Authorization', 'Bearer access_token', required: true
  param :achievement, Hash, required: true do
    param :achievement_name,     String, required: true
    param :max_rewards,          String, required: true, desc: "Should be one of '1 per day', '1 per week', '1 per month', 'unlimited'"
    param :available_for,          String, required: true, desc: "Should be one of 'users', 'devices', 'users and devices'"
    param :reward_expiry,        Integer, required: false
    param :reward_issue_requires_approval, [true, false], required: false
    param :notify_by_email, [true, false], required: false
    param :notify_via_broadcasts, [true, false], required: false
    param :giftbit_brand_ids, Array, required: false, desc: "Can be used only for GiftbitConfig and can have ids of brands for this config"
    param :use_all_config_brands, [true, false], required: false, desc: "Can be used only for GiftbitConfig."
  end

  example '
  {
    "achievement": {
      "id": 15,
      "achievement_name": "test_app_giftbit_api1",
      "points_required": 120,
      "max_rewards": "1 per month",
      "available_for": "users",
      "reward_expiry": 0,
      "reward_issue_requires_approval": false,
      "notify_by_email": false,
      "mode_type": "GiftbitConfig",
      "mode_id": 4,
      "notify_via_broadcasts": true,
      "reward_can_be_claimed": false,
      "achievement_brands": [
        {
          "id": 7,
          "giftbit_config_id": 4,
          "gift_name": "$12 playstation Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Playstation_template_id",
          "email_subject": "",
          "email_body": ""
        }
      ]
    }
  }'
  def update; end

  api :DELETE, '/achievements/:id', "Remove achievement"
  header 'Authorization', 'Bearer access_token', required: true
  example '{
   fail: "Could not remove achievement"
}'
  def destroy; end
end
