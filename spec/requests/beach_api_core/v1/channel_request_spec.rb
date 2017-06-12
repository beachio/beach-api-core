require 'rails_helper'

module BeachApiCore
  describe 'V1::Channel', type: :request do
    CHANNEL_KEYS = %i(channel id).freeze

    describe 'when index' do
      include_context 'signed up developer'
      include_context 'authenticated user'
      include_context 'bearer token authentication'

      context 'when invalid' do
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_channels_path }
        end
        it_behaves_like 'an authenticated resource' do
          before { get beach_api_core.v1_channels_path, headers: invalid_bearer_auth }
        end

        context 'with authenticated user' do
          let(:entity) { build :entity }

          it 'should return bad request if uid is not provided' do
            expect do
              get beach_api_core.v1_channels_path(entity: { kind: entity.kind }), headers: bearer_auth
            end.to raise_error(ActionController::ParameterMissing)
          end

          it 'should return bad request if kind is not provided' do
            expect do
              get beach_api_core.v1_channels_path(entity: { uid: entity.uid }), headers: bearer_auth
            end.to raise_error(ActionController::ParameterMissing)
          end
        end
      end

      context 'when valid' do
        let(:entity) { build :entity, user: oauth_user }

        context 'without entity param' do
          before { entity.save! }

          it 'it should return only UserChannel ' do
            get beach_api_core.v1_channels_path, headers: bearer_auth
            expect(response.status).to eq 200
            expect(json_body[:channels]).to be_present
            expect(json_body[:channels].size).to eq 1
            expect(json_body[:channels].first.keys).to contain_exactly(*CHANNEL_KEYS)
            expect(json_body[:channels].first[:channel]).to eq 'UserChannel'
            expect(json_body[:channels].first[:id]).to eq oauth_user.id
          end
        end


        context 'with entity param' do
          context 'when entity exists' do
            before { entity.save! }

            it 'should return both UserChannel and EntityChannel' do
              get beach_api_core.v1_channels_path(entity: { uid: entity.uid, kind: entity.kind }), headers: bearer_auth
              expect(response.status).to eq 200
              expect(json_body[:channels]).to be_present
              expect(json_body[:channels].size).to eq 2
              json_body[:channels].each { |channel| expect(channel.keys).to contain_exactly(*CHANNEL_KEYS) }
              channels_response = json_body[:channels].sort_by { |channel| channel[:channel] }
              expect(channels_response.first[:channel]).to eq 'EntityChannel'
              expect(channels_response.first[:id]).to eq entity.id
              expect(channels_response.second[:channel]).to eq 'UserChannel'
              expect(channels_response.second[:id]).to eq oauth_user.id
            end
          end

          context "when entity doesn't exist" do
            it 'it should return only UserChannel' do
              get beach_api_core.v1_channels_path(entity: { uid: entity.uid, kind: entity.kind }), headers: bearer_auth
              expect(response.status).to eq 200
              expect(json_body[:channels]).to be_present
              expect(json_body[:channels].size).to eq 1
              expect(json_body[:channels].first.keys).to contain_exactly(*CHANNEL_KEYS)
              expect(json_body[:channels].first[:channel]).to eq 'UserChannel'
              expect(json_body[:channels].first[:id]).to eq oauth_user.id
            end
          end
        end
      end
    end
  end
end
