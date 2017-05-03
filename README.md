[ ![Codeship Status for beachio/beach-api-core](https://app.codeship.com/projects/0589cfb0-ccde-0134-cf09-32338ebbb7ed/status?branch=master)](https://app.codeship.com/projects/200292)

# Beach Api Core Engine
Short description and motivation.

## Usage
How to use my plugin.

## Requirements
If you want to use [elasticsearch](#elasticsearch) you need to start sidekiq in your main app for `elsaticsearch` query.
For cloud66 you can add to your main project's Procfile:

```
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -q elasticsearch
```

In order to send emails using **Emails API** endpoints you need to start sidekiq queue in your main app for `email` query.
For cloud66 you can add to your main project's Procfile:

```
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -q email
```

To use **Jobs API** you need to run rake task from your main app:
```bash
$ rake beach_api_core:jobs:cron_init
```
And launch sidekiq `job` query:

```
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -q job
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'beach_api_core', git: 'https://github.com/beachio/beach-api-core'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install beach_api_core
```

Next, you need to run the generator:
```bash
$ rails beach_api_core:install:migrations
```

## Elasticsearch
To use elasticsearch for storing models data and for search you need to set `ELASTICSEARCH_ENABLED` ENV variable to `"true"` inside of your main app.

After that you can include `::BeachApiCore::Concerns::ElasticsearchIndexable` module to your model to trigger sidekiq to reindex elasticsearch data.
You can specify serializer class for elasticsearch index inside of your model as:
```ruby
elasticsearch_serializer '::SomeNamespace::SomeSerializer'
```

## Development
run migrations:
```
rake app:db:create
rake app:db:migrate
rake app:db:test:prepare
```
run seeds:
```
rake beach_api_core:seed
```
## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
