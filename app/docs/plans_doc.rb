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
    param :amount, Integer, required: true, desc: 'Plan price in cents'
    param :interval, %w(day month year), required: true
    param :stripe_id, String, required: true, desc: 'Unique plan name for stripe'
    param :plan_for, %w(organisation user), required: true
  end
  example "\"plan\": #{apipie_plan_response}"
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