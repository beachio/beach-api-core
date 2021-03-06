source 'https://rubygems.org'

ruby '2.4.1'

# Declare your gem's dependencies in beach_api_core.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'faker'
gem 'stripe_event'
gem 'refile', require: 'refile/rails', git: 'https://github.com/manfe/refile.git'

gem 'elasticsearch-model', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'sidekiq'
gem 'aws-sdk'
gem 'doorkeeper', '4.3.2'
gem 'stripe'
gem 'whenever'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_bot'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubocop-git'
  gem 'awesome_print'
  gem 'rspec-json_expectations'
end

group :development do
  gem 'ultrahook'
end

group :test do
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'shoulda-matchers', git: 'https://github.com/Privy/shoulda-matchers.git'
  gem 'webmock'
end

gem 'pg', '~> 0.18'

gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin.git', ref: '54dcfe'
gem 'ancestry'
gem 'apipie-rails', git: 'https://github.com/vitalinfo/apipie-rails.git'
gem 'paper_trail'
gem 'rack-cors', require: 'rack/cors'
gem 'api-ai-ruby', require: 'api-ai-ruby'
