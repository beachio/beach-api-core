require 'rails_helper'

module BeachApiCore
  describe 'Admin::PreviewAuthController', type: :request do

    include_context 'signed up admin'
    include_context 'authenticated user'
    include_context 'bearer token authentication'

    let(:user){FactoryBot.create :admin}
    
    describe "show" do

      # it "by admin" do
      #   get beach_api_core.admin_preview_auth_path(id: 2), headers: bearer_auth
      #   expect(response.status).to eq 200    
      # end

    
      it "user not a admin" do
        get beach_api_core.admin_preview_auth_path(id: 2)
        expect(response.status).to eq 401 
      end

    end
  end
end