module SubscriptionsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/subscriptions', 'Create a subscription'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :subscription, Hash, required: true do
    param :plan_id, Integer, required: true
    param :subscription_for, %w(organisation user), required: true
    param :organisation_id, Integer, required: false, desc: "Required only in case of subscription for organisation"
  end
  example '
  {
      "subscription": {
          "id": 5,
          "subscription_for": "user",
          "plan": {
              "id": 6,
              "stripe_id": "test1",
              "name": "Test Stripe",
              "amount": 2311,
              "interval": "month",
              "plan_for": "user"
          }
      }
  }'
  def create; end

  api :POST, '/subscriptions', 'create_customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :card_params, Hash, required: true do
    param :number, Integer, required: true
    param :cvc, Integer, required: true
    param :exp_month, Integer, required: true
    param :exp_year, Integer, required: true
  end
  example '"message": "Customer created successfully"'
  def create_customer; end

  api :GET, '/subscriptions/:id', 'Show subscription'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '
  {
      "subscription": {
          "id": 4,
          "subscription_for": "user",
          "plan": {
              "id": 6,
              "stripe_id": "test1",
              "name": "Test Stripe",
              "amount": 2311,
              "interval": "month",
              "plan_for": "user"
          }
      }
  }'
  def show; end

  api :PUT, '/subscriptions/:id', 'Update Subscription plan'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :subscription, Hash, required: true do
    param :plan_id, Integer, required: true
  end
  example '
  {
      "subscription": {
          "id": 6,
          "subscription_for": "user",
          "plan": {
              "id": 6,
              "stripe_id": "test1",
              "name": "Test Stripe",
              "amount": 2311,
              "interval": "month",
              "plan_for": "user"
          }
      }
  }'
  def update; end

  api :DELETE, '/subscriptions/:id', "Cancel Subscription"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
    "error": {
        "message": "Can\'t delete subscription"
    }
}'
end