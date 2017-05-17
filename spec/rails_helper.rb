ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'

Rails.backtrace_cleaner.remove_silencers!
ActiveRecord::Migration[5.1].maintain_test_schema!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/factories"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
