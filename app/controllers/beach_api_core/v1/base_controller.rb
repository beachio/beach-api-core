require_dependency 'beach_api_core/application_controller'

module BeachApiCore
  class V1::BaseController < ApplicationController
    include Pundit
    include BeachApiCore::Concerns::V1::RescueFromConcern
    include BeachApiCore::Concerns::V1::BaseControllerConcern
  end
end
