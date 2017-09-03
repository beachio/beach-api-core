[ ![Codeship Status for beachio/beach-api-core](https://app.codeship.com/projects/0589cfb0-ccde-0134-cf09-32338ebbb7ed/status?branch=master)](https://app.codeship.com/projects/200292)

# Beach Api Core Engine

Beach API Core Engine is designed to provide out of the box, a full range of features necessary to build backend Services and API's to power the next generation of User Experiences - from Mobile applications, modern Web Applications, Enterprise SaaS products, chatbots, voice bots, IoT devices and more.

Heck, it's designed to be the foundation of a complete micro-services architecture for your business.

This Engine is designed for organisations and teams that want to focus on building out their Domain Specific knowledge and functionality and bringing these services to their audiences faster and more effectively than ever before.

Not only does Beach API Core give you rich Development features, it also present new Business opportunities, enabling to to control how Developers interact with your API services, under subscription plans which you define, with Developer accounts and Sandboxed Applications - opening new Channels for your business Services.

It's designed so that your own custom business domain logic can sit in its own Engine and interact with this Engine's features (in manny, many ways!), so you can keep your valuable intellectual property private, secure and seperated from all this stuff.

## Features

- Single Federated User Identity with Permissions Scopes
- User Roles & Policies
- Invitations & Memberships
- Developer OAuth Applications
- Existing Models / Classes / Relations for popular use cases - Organisations, Teams, Projects, Favourites, Interactions etc.
- Jobs Scheduling Service
- Email Service with Templating
- Permissions Service
- Webhooks
- Entity mapping for external integrations that want to consume Platform Services
- Auto Generating Documentation
- Real-time websockets notifications & Chat service
- Developer Accounts - Define Pricing Plans for consumption of your API
- Payments & Subscriptions - Enable app Developers to define Pricing Plans for their client Applications
- Services & Integrations - exposing Engine functionalities and 3rd party integrations through Service wrappers

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

Steve - Beach Core Team
Vital - Beach Core Team
Kate - Beach Core Team


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
