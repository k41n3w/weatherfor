# Weatherfor

[![Ruby Gem](https://github.com/k41n3w/weatherfor/actions/workflows/gem-push.yml/badge.svg)](https://github.com/k41n3w/weatherfor/actions/workflows/gem-push.yml)  <a href="https://codeclimate.com/github/k41n3w/weatherfor/maintainability"><img src="https://api.codeclimate.com/v1/badges/11442e37d318544985fe/maintainability" /></a>

Welcome to Weatherfor gem! 

The purpose of this Gem is to make API requests to OpenWeatherAPI to query meteorological data to process the average temperature for the next five days.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weatherfor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weatherfor

## Usage

After you install the gem you'll have access to this methods:

To instance the gem class
```ruby
req = Weatherfor::ApiConsultant.new(CityName, OpenWeatherApiKey)
```

With this initialization you can check the parsed data:

Methodo to consult average temperature in days:
```ruby
req.weather_in_days
```

This will bring a message like that:

    34°C e nublado em <cidade> em 12/12. Média para os próximos dias: 32°C em 13/12, 25°C em 14/12, 29°C em 15/12, 33°C em 16/12 e 28°C em 16/12.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/k41n3w/weatherfor.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
