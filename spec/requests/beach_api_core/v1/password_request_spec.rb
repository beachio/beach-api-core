require 'rails_helper'

module BeachApiCore
  describe 'V1::Password', type: :request do

    describe 'when create' do
      let(:user) { create :user }
      it 'should send reset password instructions' do
        expect do
          post beach_api_core.v1_password_path,
               params: { email: user.email }
        end.to change(ActionMailer::Base.deliveries, :size).by(1)
        expect(response.status).to eq 200
        expect(user.reload.reset_password_token).to be_present
      end
    end

    describe 'when update' do
      let(:new_password) { Faker::Internet.password }
      let(:token) { SecureRandom.urlsafe_base64 }
      let(:user) { create :user, reset_password_token: token }

      it "should reset user's password" do
        expect do
          put beach_api_core.v1_password_path,
              params: {
                token: token,
                password: new_password,
                password_confirmation: new_password }
        end.to change { user.reload.password_digest }
        expect(response.status).to eq 200
      end

      it 'should should return error' do
        put beach_api_core.v1_password_path,
            params: {
              token: 'invalid',
              password: new_password,
              password_confirmation: new_password }
        expect(response.status).to eq 400
        expect(json_body[:error][:message]).to eq('Invalid token')
      end
    end
  end
end
