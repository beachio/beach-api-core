Rails.application.routes.draw do
  mount BeachApiCore::Engine => "/beach_api_core"
end
