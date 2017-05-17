require 'rails_helper'

module BeachApiCore
  describe 'V1::Session', type: :request do
    include_context 'signed up developer'
    include_context 'bearer token authentication'

    context 'when valid' do
      it 'should access the bearer token' do
        post beach_api_core.oauth_token_path,
             params: { email: developer.email,
                       password: developer.password,
                       grant_type: 'password' }
        expect(json_body[:access_token]).to be_present
      end

      it 'should return the bearer token on signin' do
        post beach_api_core.v1_sessions_path,
             params: {
               session: { email: developer.email,
                          password: developer.password }
             },
             headers: application_auth
        expect(response.status).to eq 200
        expect(json_body[:user]).to be_present
        expect(json_body[:access_token]).to be_present
      end

      it 'should authorize' do
        post beach_api_core.v1_sessions_path,
             params: { session: { email: developer.email, password: developer.password } },
             headers: application_auth
        expect(response.status).to eq 200
        expect(json_body[:user]).to be_present
      end
    end

    it 'when invalid' do
      user = create :user
      [{ params: { email: Faker::Internet.email, password: Faker::Internet.password }, status: 401 },
       { params: { email: user.email, password: Faker::Internet.password }, status: 401 },
       { params: { email: user.email }, headers: application_auth, status: 400 },
       { params: { email: Faker::Internet.email }, status: 401 },
       { params: { password: Faker::Internet.password }, headers: application_auth, status: 400 }].each do |data|
        post beach_api_core.v1_sessions_path,
             params: { session: data[:params] },
             headers: data[:headers]
        expect(response.status).to eq(data[:status])
        expect(json_body[:error][:message]).to_not be_nil
      end
    end
  end
end
