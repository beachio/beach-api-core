require 'rails_helper'

module BeachApiCore
  describe 'V1::Session', type: :request do

    context 'when valid' do
      let(:user) { create :user }

      it 'should access the bearer token' do
        post beach_api_core.oauth_token_path, params: {
            email: user.email,
            password: user.password,
            grant_type: 'password'
        }
        expect(json_body[:access_token]).to be_present
      end

      it 'should authorize' do
        post beach_api_core.v1_sessions_path, params: { session: { email: user.email, password: user.password } }
        expect(response.status).to eq(200)
        expect(json_body[:user]).to be_present
      end
    end

    it 'when invalid' do
      user  = create :user
      [{ params: { email: Faker::Internet.email, password: Faker::Internet.password }, status: 404 },
       { params: { email: user.email, password: Faker::Internet.password }, status: 401 },
       { params: { email: user.email }, status: 400 },
       { params: { email: Faker::Internet.email }, status: 400 },
       { params: { password: Faker::Internet.password }, status: 400   }].each do |data|
        post beach_api_core.v1_sessions_path, params: { session: data[:params] }
        expect(response.status).to eq(data[:status])
        expect(json_body[:error][:message]).to_not be_nil
      end
    end

  end
end