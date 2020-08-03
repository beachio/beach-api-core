require 'rails_helper'

module BeachApiCore
  RSpec.describe V1::NotificationsController, type: :controller do
    describe "GET index" do
      it "returns notification list" do
        _notification = Notification.create
        get :index
        # expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
      end
    end

    describe "DELETE destroy" do
      it "delete notification" do
        delete :destroy
        # expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
      end
    end
  end
end
