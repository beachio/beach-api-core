require_dependency "beach_api_core/application_controller"

module BeachApiCore
  class Admin::EndpointsController < ApplicationController
    def handlers
      # render json: MixfitCore::Handler.all.map{|h| h.params}.select{|t| !t[:hidden]}
      render json: []
    end
  end
end
