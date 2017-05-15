module SubscriptionsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/subscriptions', 'Create a subscription for organisation by organisation owner'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :subscription, Hash, required: true do
    param :stripeToken, String, required: true
    param :stripeEmail, String, required: true
    param :plan_id, Integer, required: true
  end
  example "\"message\": success"
  def create
  end
end
