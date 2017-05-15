require 'rails_helper'

module BeachApiCore
  describe 'V1::Subscription', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      let!(:subscription_plan) { create :subscription_plan }
      let!(:owned_organisation) do
        (create :membership, member: oauth_user, group: (create :organisation), owner: true).group
      end

      before do
        @subscription_params = {
          subscription: {
            plan_id: subscription_plan.id,
            stripeToken: '',
            stripeEmail: Faker::Internet.email
          }
        }
        access_token.update(organisation: owned_organisation)
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_subscriptions_path, params: @subscription_params }
      end

      it 'should create a new subscription' do
        post beach_api_core.v1_subscriptions_path,
             params: @subscription_params,
             headers: bearer_auth
        expect(response.status).to eq 201
        expect(json_body[:message]).to be_present
        expect(json_body[:message]).to eq 'success'
      end
    end
  end
end
