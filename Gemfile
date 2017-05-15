source 'https://rubygems.org'

ruby '2.3.1'

# Declare your gem's dependencies in beach_api_core.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'refile', require: 'refile/rails', git: 'https://github.com/manfe/refile.git'
gem 'faker'

gem 'sidekiq', '~> 4.2.9'
gem 'elasticsearch-model', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'https://github.com/elasticsearch/elasticsearch-rails.git'
# @todo: remove "git" option for payola as soon as PR https://github.com/payolapayments/payola/pull/302 is merged
gem 'payola-payments', git: 'https://github.com/alekseenko/payola'

group :development, :test do
  gem 'rspec-rails'
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'webmock'
  gem 'poltergeist'
  gem 'shoulda-matchers', git: 'https://github.com/Privy/shoulda-matchers'
end

gem 'apipie-rails', git: 'https://github.com/vitalinfo/apipie-rails'
