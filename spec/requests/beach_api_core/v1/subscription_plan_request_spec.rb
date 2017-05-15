require 'rails_helper'

module BeachApiCore
  describe 'V1::SubscriptionPlan', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when index' do
      it_behaves_like 'an authenticated resource' do
        before { get beach_api_core.v1_subscription_plans_path }
      end

      describe 'should list all available subscription plans' do
        before { 2.times { create :subscription_plan } }
        it do
          get beach_api_core.v1_subscription_plans_path, headers: bearer_auth
          expect(response.status).to eq 200
          expect(json_body[:subscription_plans]).to be_present
          expect(json_body[:subscription_plans].size).to eq 2
        end
      end
    end

    describe 'when create' do
      before do
        @subscription_plan_params = {
          subscription_plan: {
            name: Faker::Name.title,
            stripe_id: Faker::Lorem.word,
            amount: Faker::Number.between(1000, 10000),
            interval: %w(day month year).sample
          }
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_subscription_plans_path, params: @subscription_plan_params }
      end

      it 'should create a new subscription plan' do
        post beach_api_core.v1_subscription_plans_path,
             params: @subscription_plan_params,
             headers: bearer_auth
        expect(response.status).to eq 201
        expect(json_body[:subscription_plan]).to be_present
        expect(json_body[:subscription_plan].keys).to contain_exactly(:id, :stripe_id, :name, :amount, :interval)
        expect(json_body[:subscription_plan][:name]).to eq @subscription_plan_params[:subscription_plan][:name]
      end
    end
  end
end
