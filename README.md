# Mapboxkit

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mapboxkit'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mapboxkit

## Usage

```rb
Mapboxkit.configure do |config|
  config.access_token = ENV['MAPBOX_ACCESS_TOKEN']
end

# List your map's styles
Mapboxkit.styles('__your_username__')
```

You can also create an Mapboxkit::Client instance manually.

```rb
client = Mapboxkit::Client.new(access_token: consumer.access_token)

# List consumer's map styles
client.styles('__your_username__')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yamap-inc/mapboxkit-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yamap-inc/mapboxkit-rb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mapboxkit project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yamap-inc/mapboxkit-rb/blob/main/CODE_OF_CONDUCT.md).
