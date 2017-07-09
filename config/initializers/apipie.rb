Apipie.configure do |config|
  config.api_controllers_matcher = [] unless config.api_controllers_matcher.is_a?(Array)
  config.api_controllers_matcher << "#{File.expand_path('../../..', __FILE__)}/app/controllers/**/*.rb"
  config.app_name                = 'Beach API Core'
  config.app_info                = 'Beach API Core v1 is currently the default API version'
  config.api_base_url['v1']      = '/v1'
  config.doc_base_url            = '/api'
  config.validate                = :explicitly
  config.default_version         = 'v1'
end
