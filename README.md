# LIFX::HTTP

[![Build Status](https://travis-ci.org/tatey/lifx-http-client-ruby.svg?branch=master)](https://travis-ci.org/tatey/lifx-http-client-ruby)

A nice Ruby client for the LIFX HTTP API that has *no* external dependencies.
Generate a personal access token at https://cloud.lifx.com/settings.

``` ruby
lifx     = LIFX::HTTP::Client.new(access_token: 'c87c73a896b554367fac61f71dd3656af8d93a525a4e87df5952c6078a89d192')
response = lifx.set_lights_color(selector: 'all', color: 'blue', duration: 3)
response.success? # => true
response.statuses # => [#<Result @id='43b2f2d97452', @status='ok'>, ...]
```

## Installation

Add this line to your Gemfile.

``` ruby
gem 'lifx-http', require: 'lifx/http', github: 'tatey/lifx-http-client-ruby'
```

Run bundler to install it.

``` sh
$ bundle
```

## Usage

### Determining if a response was successful

Use the `success?` predicate to determine if the response was successful.

``` ruby
response = lifx.set_lights_power(selector: 'all', state: 'on')
if response.success?
  response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
end
```

Alternatively, you can opt-in to an exception on failure or `self`
on success.

``` ruby
# Failure
response = lifx.set_lights_power(selector: 'all', state: 'off').success! # => LIFX::HTTP:UnexpectedStatusError

# Success
response = lifx.set_lights_power(selector: 'all', state: 'on').success!
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

### List of operations

Get all lights.

``` ruby
lifx.lights
response.lights # => [#<LIFX::HTTP::Loader::Device @id='43b2f2d97452', ...>, ...]
```

Get only the lights which match the given selector.

``` ruby
response = lifx.lights(selector: 'id:43b2f2d97452')
response.statuses # => [#<LIFX::HTTP::Loader::Device @id='43b2f2d97452', ...>, ...]
```

Turns the lights on or off.

``` ruby
response = lifx.set_lights_power(selector: 'all', state: 'on')
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

Toggle the lights between on and off.

``` ruby
response = lifx.toggle(selector: 'all')
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

Change the color of the lights.

``` ruby
response = lifx.set_color(selector: 'all', color: 'blue')
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

Run the breathe effect on the lights.

``` ruby
response = lifx.run_breathe_effect(selector: 'all', color: 'blue', cycles: 3)
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

Run the pulse effect on the lights.

``` ruby
response = lifx.run_pulse_effect(selector: 'all', color: 'blue', cycles: 3)
response.statuses # => [#<LIFX::HTTP::Loader::Result @id='43b2f2d97452', @status='ok'>, ...]
```

### Differences from the API

All successful responses will contain an array of objects, even if a
single object is returned. This makes it easier to consume the result.

## Tests

Run the entire test suite.

``` sh
$ [bundle exec] rake
```

## Contributing

1. Fork it (https://github.com/tatey/lifx-http-client-ruby/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
