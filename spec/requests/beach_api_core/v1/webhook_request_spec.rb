require 'rails_helper'

module BeachApiCore
  describe 'V1::Webhook', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    WEBHOOK_KEYS = %i(id uri kind keeper_id).freeze

    describe 'when create' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_webhooks_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_webhooks_path, headers: invalid_app_auth }
        end

        it 'should return bad request status if webhook is invalid' do
          webhook_params = { kind: 'organisation_created' }
          expect do
            post beach_api_core.v1_webhooks_path, params: { webhook: webhook_params }, headers: application_auth
          end.not_to change(Webhook, :count)
          expect(response.status).to eq 400
          expect(json_body[:error]).to be_present
        end
      end

      context 'when valid' do
        let(:webhook_params) do
          { uri: Faker::Internet.url, kind: 'user_created' }
        end
        it 'should create new webhook with correct fields' do
          expect do
            post beach_api_core.v1_webhooks_path, params: { webhook: webhook_params }, headers: application_auth
          end.to change(Webhook, :count).by(1)
          webhook = Webhook.last
          %i(uri kind).each { |key| expect(webhook.send(key)).to eq webhook_params[key] }
          expect(webhook.keeper_id).to eq oauth_application.id
        end

        it 'should return webhook' do
          post beach_api_core.v1_webhooks_path, params: { webhook: webhook_params }, headers: application_auth
          webhook = Webhook.last
          expect(response.status).to eq 200
          expect(json_body[:webhook]).to be_present
          expect(json_body[:webhook].keys).to contain_exactly(*WEBHOOK_KEYS)
          WEBHOOK_KEYS.each { |key| expect(json_body[:webhook][key]).to eq webhook.send(key) }
        end
      end
    end

    describe 'when destroy' do
      context 'when invalid' do
        let(:webhook) { create :webhook }
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_webhook_path(webhook) }
        end
        it_behaves_like 'an authenticated resource' do
          before { delete beach_api_core.v1_webhook_path(webhook), headers: invalid_app_auth }
        end
        it_behaves_like 'an forbidden resource' do
          before { delete beach_api_core.v1_webhook_path(webhook), headers: application_auth }
        end
      end

      context 'when valid' do
        it 'should remove webhook' do
          webhook = create(:webhook, keeper: oauth_application)
          delete beach_api_core.v1_webhook_path(webhook), headers: application_auth
          expect(response.status).to eq 204
          expect(Webhook.find_by(id: webhook.id)).to be_blank
        end
      end
    end

    describe 'when index' do
      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_webhooks_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_webhooks_path, headers: invalid_app_auth }
        end
      end

      context 'when valid' do
        before do
          create(:webhook, keeper: oauth_application)
          create(:webhook)
        end
        it 'without filter' do
          get beach_api_core.v1_webhooks_path, headers: application_auth
          expect(response.status).to eq 200
          expect(json_body[:webhooks]).to be_present
          expect(json_body[:webhooks].size).to eq 1
          expect(json_body[:webhooks].first.keys).to contain_exactly(*WEBHOOK_KEYS)
        end
      end
    end
  end
end
