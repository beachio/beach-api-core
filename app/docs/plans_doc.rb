module PlansDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/plans', 'List all plans'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"plans\": [#{apipie_plan_response}, ...]"
  def index; end

  api :GET, '/plans/:id', 'Show plan'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"plan\": #{apipie_plan_response}"
  def show; end

  api :POST, '/plans', 'Create a new plan'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :plan, Hash, required: true do
    param :name, String, required: true, desc: 'Human readable name of a plan'
    param :amount, Integer, required: true
    param :interval, %w(day month year), required: true, desc: 'Period for plan: day, month or year'
    param :stripe_id, String, required: true, desc: 'Unique plan name for stripe'
    param :plan_for, %w(organisation user), required: true, desc: 'Choose plan for keeper type: user or organisation'
    param :trial_period_days, Integer, required: false, desc: 'Trial period at days'
    param :billing_scheme, %w(tiered), required: false, desc: 'Required if plan_for \'organiastion\': Scheme for plan'
    param :tiers, Array, required: false, desc: 'Required if billing_scheme = "tiered" :: Add tiers for plan'
    param :tiers_mode, %w(graduated),required: false, desc: 'Required if billing_scheme = "tiered" :: Add mode of tiers for plan'
    param :currency, String, required: true, desc: 'Add currency for plan'
  end
  example "{
      \"plan\":{
          \"amount\": 1999,
          \"name\": \"Pllan for organisations\",
          \"interval\": \"month\",
          \"stripe_id\": \"Pllan_for_organisation\",
          \"plan_for\": \"organisation\",
          \"billing_scheme\": \"tiered\",
          \"tiers\": [{\"unit_amount\":0, \"up_to\":5, \"flat_amount\": 700},{\"unit_amount\":300, \"up_to\":\"inf\"}],
          \"users_count\": 10,
          \"amount_per_additional_user\": 100,
          \"trial_period_days\": 3,
          \"currency\": \"usd\",
          \"tiers_mode\": \"graduated\"
      }
  }
  \"plan\": #{apipie_plan_response}"
  def create; end

  api :DELETE, '/plans/:id', "Remove plan"
  header 'Authorization', 'Bearer access_token', required: true
  example '{
    "error": {
        "message": "Could not remove plan"
    }
}'
  def destroy; end
end