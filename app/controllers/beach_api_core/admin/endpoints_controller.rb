require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::EndpointsController < ApplicationController
    before_action :authenticate_admin_user!

    def handlers
      render json: MixfitCore::Handler.all.map{|h| h.params}
    end
  end
end
