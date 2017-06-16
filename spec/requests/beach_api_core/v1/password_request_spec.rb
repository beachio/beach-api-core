require 'rails_helper'

module BeachApiCore
  describe 'V1::Password', type: :request do
    include_context 'signed up developer'
    include_context 'bearer token authentication'
    include_context 'controller actions permissions'

    before do
      create :setting, keeper: oauth_application, name: :noreply_from, value: Faker::Internet.email
      create :setting, keeper: oauth_application, name: :client_domain, value: Faker::Internet.redirect_uri
    end

    describe 'when create' do
      let(:user) { create :user }
      it 'should send reset password instructions' do
        expect do
          post beach_api_core.v1_password_path,
               headers: application_auth,
               params: { email: user.email }
        end.to change(ActionMailer::Base.deliveries, :size).by(1)
        expect(response.status).to eq 200
        expect(json_body[:user].keys).to contain_exactly(*BeachApiCore::USER_SIMPLE_KEYS)
        expect(user.reload.reset_password_token).to be_present
      end

      it_behaves_like 'an authenticated resource' do
        before do
          post beach_api_core.v1_password_path,
               headers: invalid_app_auth,
               params: { email: user.email }
        end
      end
    end

    describe 'when update' do
      let(:new_password) { Faker::Internet.password }
      let(:token) { SecureRandom.urlsafe_base64 }
      let(:user) { create :user, reset_password_token: token }

      it "should reset user's password" do
        expect do
          put beach_api_core.v1_password_path,
              headers: application_auth,
              params: { token: token,
                        password: new_password,
                        password_confirmation: new_password }
        end.to(change { user.reload.password_digest })
        expect(response.status).to eq 200
        expect(json_body[:user].keys).to contain_exactly(*BeachApiCore::USER_SIMPLE_KEYS)
      end

      it 'should should return error' do
        put beach_api_core.v1_password_path,
            headers: application_auth,
            params: { token: 'invalid',
                      password: new_password,
                      password_confirmation: new_password }
        expect(response.status).to eq 400
        expect(json_body[:error][:message]).to eq('Invalid token')
      end

      it_behaves_like 'an authenticated resource' do
        before do
          put beach_api_core.v1_password_path,
              headers: invalid_app_auth,
              params: { token: token,
                        password: new_password,
                        password_confirmation: new_password }
        end
      end
    end
  end
end
