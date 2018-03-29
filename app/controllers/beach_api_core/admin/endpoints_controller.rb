require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::EndpointsController < ApplicationController
    bofore_action :authenticate_admin_user!

    def index
      render json: [{name: "Submit Task", id: "MixfitCore::Task" }, {name: "Submit Challenge", id: "MixfitCore::Challenge" }]
    end

    def show
      render json: params[:id].constantize.all, adapter: :attributes
    end

    def update
    end
  end
end
