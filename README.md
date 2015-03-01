# LIFX::HTTP

A nice Ruby client for the LIFX HTTP API. No external dependencies.

``` ruby
lifx     = LIFX::HTTP::Client.new(access_token: 'c87c73a896b554367fac61f71dd3656af8d93a525a4e87df5952c6078a89d192')
response = lifx.put_lights_color(selector: 'all', color: 'blue', duration: 3)
response.success? # => true
response.object   # => [#<Result id: '43b2f2d97452', status: 'ok'>]
```

## Installation

Add this line to your Gemfile.

``` ruby
gem 'lifx-http', github: 'tatey/lifx-http-client-ruby'
```

Run bundler to install it.

``` sh
$ bundle
```

## Usage

### Determining if a response was successful

Use the `success?` predicate to determine if the response was successful.

``` ruby
response = lifx.put_power(selector: 'all', state: 'on')
response.success? # => true
response.object   # => [#<Result id: '43b2f2d97452', status: 'ok'>]
```

Alternatively, you can opt-in to an exception on failure or `self`
on success.

``` ruby
# Failure
response = lifx.put_power(selector: 'all', state: 'off').success! # => LIFX::HTTP:UnexpectedStatusError

# Success
response = lifx.put_power(selector: 'all', state: 'on').success!
response.object # => [#<Result id: '43b2f2d97452', status: 'ok'>]
```

### List of operations

Get all lights.

``` ruby
lifx.get_lights
```

Get a subset of lights.

``` ruby
lifx.get_lights(selector: 'id:43b2f2d97452')
```

Set the power state of the lights.

``` ruby
lifx.put_power(selector: 'all', state: 'on')
```

Toggle the power state of the lights.

``` ruby
lifx.post_toggle(selector: 'all')
```

Set color of lights.

``` ruby
lifx.put_lights_color(selector: 'all', color: 'blue')
```

Perform a breath effect on lights.

``` ruby
lifx.post_lights_effect_breathe(selector: 'all', color: 'blue', cycles: 3)
```

Perform a pulse effect on lights.

``` ruby
lifx.post_lights_effect_pulse(selector: 'all', color: 'blue', cycles: 3)
```

## Tests

Run the entire test suite.

``` sh
$ [bundle exec] rspec spec/lib/lifx_http_spec.rb
```

## Contributing

1. Fork it (https://github.com/tatey/lifx-http/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
