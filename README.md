[ ![Codeship Status for beachio/beach-api-core](https://app.codeship.com/projects/0589cfb0-ccde-0134-cf09-32338ebbb7ed/status?branch=master)](https://app.codeship.com/projects/200292)

# Beach Api Core Engine
Short description and motivation.

## Usage
How to use my plugin.

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

##Development
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
