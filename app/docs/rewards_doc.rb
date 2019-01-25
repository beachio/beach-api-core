module RewardsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/rewards', 'Create new reward'
  header 'Authorization', 'Bearer access_token', required: true
  param :reward, Hash, required: true do
    param :achievement_id,     Integer, required: true
    param :giftbit_brand_id,     Integer, required: false, desc: "Required only for achievement with Giftbit mode"
  end
  example '
  {
    "reward": {
      "id": 59,
      "achievement_id": 18,
      "confirmed": true,
      "status": "Pending",
      "created_at": "2019-01-22T12:59:14.621Z",
      "giftbit_brand": {
        "id": 7,
        "giftbit_config_id": 4,
        "gift_name": "$12 playstation Gift Card",
        "amount": 500,
        "brand_code": "walmart",
        "giftbit_email_template": "Playstation_template_id",
        "email_subject": "",
        "email_body": ""
      }
    }
  }'
  def create; end

  api :GET, '/rewards', 'Return all user\'s rewards'
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "rewards": [
      {
        "id": 54,
        "achievement_id": 12,
        "confirmed": true,
        "status": "Pending",
        "created_at": "2019-01-17T10:18:44.310Z"
      },
      {
        "id": 55,
        "achievement_id": 13,
        "confirmed": true,
        "status": "Pending",
        "created_at": "2019-01-17T10:19:43.220Z",
        "giftbit_brand": {
          "id": 7,
          "giftbit_config_id": 4,
          "gift_name": "$5 Walmart Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Walmart_template_id",
          "email_subject": "",
          "email_body": ""
        }
      }
    ]
  }'
  def index; end

  api :GET, '/rewards/:id', 'Return reward data'
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "reward": {
      "id": 45,
      "achievement_id": 9,
      "confirmed": true,
      "status": "Spent",
      "created_at": "2019-01-14T11:38:38.127Z"
    }
  }'
  def show; end

  api :PUT, '/rewards/:id/confirm_reward', 'Confirm reward'
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
     "message": "Confirmed",
     "reward": {
        "id": 59,
        "achievement_id": 18,
        "confirmed": true,
        "status": "Pending",
        "created_at": "2019-01-22T12:59:14.621Z",
        "giftbit_brand": {
          "id": 7,
          "giftbit_config_id": 4,
          "gift_name": "$12 playstation Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Playstation_template_id",
          "email_subject": "",
          "email_body": ""
        }
      }
  }'
  def confirm_reward; end

  api :PUT, '/rewards/resend_gift/:uuid', 'Resend Gift'
  header 'Authorization', 'Bearer access_token', required: true
  example '{
   "message": "The gift has been resent.",
   "status": 200
}'
  def resend_gift; end


  api :DELETE, '/rewards/cancel_gift/:uuid', 'Cancel Gift'
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "message": "The gift has been canceled.",
    "reward": {
      "id": 59,
      "achievement_id": 18,
      "confirmed": true,
      "status": "Closed",
      "created_at": "2019-01-22T12:59:14.621Z",
      "gift_uuid": "f0c9b59a3f944a839937718b315899e6",
      "shortlink": "http://gtbt.co/7zXFzDdWYWN",
      "giftbit_brand": {
        "id": 7,
        "giftbit_config_id": 4,
        "gift_name": "$12 playstation Gift Card",
        "amount": 500,
        "brand_code": "walmart",
        "giftbit_email_template": "Playstation_template_id",
        "email_subject": "",
        "email_body": ""
      }
    },
    "status": 200
  }'
  def cancel_gift; end

  api :DELETE, '/rewards/:id', "Remove reward"
  header 'Authorization', 'Bearer access_token', required: true
  example '{
   fail: "Could not remove reward"
}'
  def destroy; end
end
