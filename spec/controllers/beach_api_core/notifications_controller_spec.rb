require 'rails_helper'

module BeachApiCore
  RSpec.describe V1::NotificationsController, type: :controller do
    routes { BeachApiCore::Engine.routes }

    include_context 'signed up developer'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    describe 'GET index' do
      it 'returns notification list' do
        notification = BeachApiCore::Notification.create(user: oauth_user, kind: :ws)
        get :index
        expect(response.status).to eq(200)
        expect(json_body[:notifications]).to include_json([{ id: notification.id }])
      end
    end

    describe 'DELETE destroy' do
      it 'delete notification' do
        notification = BeachApiCore::Notification.create(user: oauth_user, kind: :ws)
        delete :destroy, params: { id: notification.id }
        expect(response.status).to eq(200)
        expect(json_body[:notification]).to include_json(id: notification.id)
        expect(BeachApiCore::Notification.all).to be_empty
      end
    end
  end
end
