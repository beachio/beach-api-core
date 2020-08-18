ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'factory_bot'
require 'refile/file_double'
require 'pundit/rspec'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'rspec/json_expectations'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

FactoryBot.definition_file_paths << "#{File.dirname(__FILE__)}/factories"
FactoryBot.definition_file_paths.uniq!
FactoryBot.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  Kernel.srand config.seed

  config.expose_dsl_globally = true

  config.after(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
