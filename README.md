# LIFX::HTTP

A nice Ruby client for the LIFX HTTP API. No external dependencies.

``` ruby
lifx     = LIFX::HTTP::Client.new(access_token: 'c87c73a896b554367fac61f71dd3656af8d93a525a4e87df5952c6078a89d192')
response = lifx.put_lights_color(selector: 'all', color: 'blue', duration: 3)
response.success? # => true
response.data     # => [#<Result id: '43b2f2d97452', status: 'ok'>]
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

Get all lights.

``` ruby
lifx.get_lights
```

Get a subset of lights.

``` ruby
lifx.get_lights(selector: 'id:43b2f2d97452')
```

Set color of lights.

``` ruby
lifx.put_lights_color(selector: 'all', color: 'blue')
```

Set the power state of the lights.

``` ruby
lifx.put_power(selector: 'all', state: 'on')
```

Toggle the power state of the lights.

``` ruby
lifx.post_toggle(selector: 'all')
```

Perform a breath effect on lights.

``` ruby
lifx.post_lights_effect_breathe(selector: 'all', color: 'blue', cycles: 3)
```

Perform a pulse effect on lights.

``` ruby
lifx.post_lights_effect_pulse(selector: 'all', color: 'blue', cycles: 3)
```

## Contributing

1. Fork it (https://github.com/tatey/lifx-http/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
