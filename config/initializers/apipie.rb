Apipie.configure do |config|
  config.app_name                = 'BeachAPI Core'
  config.api_base_url['v1']      = '/v1'
  config.doc_base_url            = '/api'
  config.validate                = false
  config.api_controllers_matcher = "#{File.expand_path('../../..', __FILE__)}/app/controllers/**/*.rb"
  config.default_version         = 'v1'
end
