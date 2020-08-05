require 'rails_helper'

module BeachApiCore
  RSpec.describe V1::NotificationsController, type: :controller do
    routes { BeachApiCore::Engine.routes }

    describe "GET index" do
      it "returns notification list" do
        notification = BeachApiCore::Notification.create
        get :index
        expect(response.status).to eq(200)
        expect(response.body).to include_json([{id: notification.id}])
      end
    end

    describe "DELETE destroy" do
      it "delete notification" do
        notification = Notification.create
        delete :destroy, params: {id: notification.id}
        expect(BeachApiCore::Notification.all).to be_empty
      end
    end
  end
end
