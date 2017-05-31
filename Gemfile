source 'https://rubygems.org'

ruby '2.4.1'

# Declare your gem's dependencies in beach_api_core.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'faker'
gem 'refile', require: 'refile/rails', git: 'https://github.com/manfe/refile.git'

gem 'elasticsearch-model', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'shoulda-matchers', git: 'https://github.com/Privy/shoulda-matchers.git'
  gem 'webmock'
end

gem 'apipie-rails', git: 'https://github.com/vitalinfo/apipie-rails.git'
