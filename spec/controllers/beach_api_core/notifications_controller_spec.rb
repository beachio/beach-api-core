require 'rails_helper'

module BeachApiCore
  RSpec.describe V1::NotificationsController, type: :controller do
    describe "GET #list_notifications" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #delete_notification" do
      it "returns http success" do
        delete :destroy
        expect(response).to have_http_status(:success)
      end
    end
  end
end
