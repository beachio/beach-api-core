require 'rails_helper'

module BeachApiCore
  RSpec.describe NotificationsController, type: :controller do

    describe "GET #list_notifications," do
      it "returns http success" do
        get :list_notifications,
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #delete_notification" do
      it "returns http success" do
        get :delete_notification
        expect(response).to have_http_status(:success)
      end
    end

  end
end
