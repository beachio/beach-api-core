require 'rails_helper'

module BeachApiCore
  describe 'V1::Broadcast', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      context 'UserChannel' do
        before do
          @channel_params = {
            name: 'UserChannel',
            id: create(:user).id,
            payload: { Faker::Lorem.word => Faker::Lorem.word }
          }
        end

        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_broadcasts_path }
        end

        it 'should send broadcats' do
          post beach_api_core.v1_broadcasts_path, params: { channel: @channel_params }, headers: application_auth
          expect(response.status).to eq 204
        end
      end

      context 'EntityChannel' do
        before do
          @channel_params = {
            name: 'EntityChannel',
            id: create(:entity).id,
            payload: { Faker::Lorem.word => Faker::Lorem.word }
          }
        end

        it_behaves_like 'an authenticated resource' do
          before { post beach_api_core.v1_broadcasts_path }
        end

        it 'should send broadcats' do
          post beach_api_core.v1_broadcasts_path, params: { channel: @channel_params }, headers: application_auth
          expect(response.status).to eq 204
        end
      end

      context 'wrong channel name' do
        before do
          @channel_params = {
            name: Faker::Lorem.word,
            id: create(:entity).id,
            payload: { Faker::Lorem.word => Faker::Lorem.word }
          }
        end

        it 'should return bad request status' do
          post beach_api_core.v1_broadcasts_path, params: { channel: @channel_params }, headers: application_auth
          expect(response.status).to eq 400
        end
      end
    end
  end
end
