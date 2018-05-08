require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::PreviewAuthController < ApplicationController
    before_action :user_admin?

    def get_auth_token
      @token = Doorkeeper::AccessToken.find_by(resource_owner_id: params[:user_id], application_id: 1)
      if @token
        render json:
        {
          auth_token: @token.token,
        } 
      else
        render json: {message: "Record not found"}, status: 404
      end
    end


    private 
    
    def user_admin?
      if current_user
        current_user.admin?
      else
        render json: {message: "Must be logged by admin"}
      end
    end
    
  end
end