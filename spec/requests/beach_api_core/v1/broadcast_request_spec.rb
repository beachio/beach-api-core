require 'rails_helper'

module BeachApiCore
  describe 'V1::Broadcast', type: :request do
    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'when create' do
      before do
        @broadcast_params = {
          user_id: create(:user).id,
          payload: { Faker::Lorem.word => Faker::Lorem.word },
        }
      end

      it_behaves_like 'an authenticated resource' do
        before { post beach_api_core.v1_broadcasts_path }
      end

      it 'should send broadcats' do
        post beach_api_core.v1_broadcasts_path,
             params: { broadcast: @broadcast_params },
             headers: application_auth
        expect(response.status).to eq 204
      end
    end
  end
end
