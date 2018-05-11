require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::PreviewAuthController < ApplicationController
    before_action :user_admin?

    
    #if you admin, u can see users tokens by owner_id
    def show
      @token = Doorkeeper::AccessToken.order("created_at DESC").find_by(resource_owner_id: params[:id])
      if @token
        render json:
        {
          auth_token: @token.token
        }, status: 200
      else
        render json: {message: "Record not found"}, status: 404
      end
    end


    private 

    
    def user_admin?
      if current_user
        current_user.admin?
      else
        render json: {message: "Must be logged by admin"}, status: 401
      end
    end
    
  end
end