source 'https://rubygems.org'

# Declare your gem's dependencies in beach_api_core.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'refile', require: 'refile/rails', git: 'https://github.com/manfe/refile.git'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug', platform: :mri
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'poltergeist'
  gem 'shoulda-matchers', git: 'https://github.com/Privy/shoulda-matchers'
end
