require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::EndpointsController < ApplicationController
    before_action :authenticate_admin_user!

    def models
      render json: BeachApiCore::Endpoint.where(request_type: params[:request_type]).pluck(:model).uniq, adapter: :attributes
    end

    def actions
      render json: BeachApiCore::Endpoint.where(request_type: params[:request_type], model: params[:model]).pluck(:action_name).uniq, adapter: :attributes
    end

    def entities
      @endpoint = BeachApiCore::Endpoint.find_by(request_type: params[:request_type], model: params[:model], action_name: params[:action_name])
      if @endpoint.on == "member"
        render json: params[:model].constantize.all, adapter: :attributes
      else
        render json: nil
      end
    end
  end
end
