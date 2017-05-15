module SubscriptionPlansDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/subscription_plans', 'List all subscription plans'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"subscription_plans\": [#{apipie_subscription_plan_response}, ...]"
  def index
  end

  api :POST, '/subscription_plans', 'Create a new subscription plan'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :subscription_plan, Hash, required: true do
    param :name, String, required: true, desc: 'Human readable name of a plan'
    param :amount, Integer, required: true, desc: 'Plan price in cents'
    param :interval, %w(day month year), required: true
    param :stripe_id, String, required: true, desc: 'Unique plan name for stripe'
  end
  example "\"subscription_plan\": #{apipie_subscription_plan_response}"
  def create
  end
end
