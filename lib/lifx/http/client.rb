require 'lifx/http/connection'
require 'lifx/http/response'

module LIFX
  module HTTP
    class Client
      def initialize(access_token:)
        @connection = Connection.new(access_token: access_token)
      end

      def user_agent
        @connection.user_agent
      end

      def lights(selector: 'all')
        Response.new(
          raw: @connection.get(path: "/v1beta1/lights/#{selector}"),
          loader: Loader::Device,
          expects: [200]
        )
      end

      def set_lights_power(selector:, state:)
        Response.new(
          raw: @connection.put(
            path: "/v1beta1/lights/#{selector}/power",
            body: {state: state}
          ),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end

      def set_lights_toggle(selector:)
        Response.new(
          raw: @connection.post(path: "/v1beta1/lights/#{selector}/toggle"),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end

      def set_lights_color(selector:, color:, duration: nil, power_on: nil)
        Response.new(
          raw: @connection.put(
            path: "/v1beta1/lights/#{selector}/color",
            body: build_body(color: color, duration: duration, power_on: power_on)
          ),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end

      def run_lights_breathe_effect(selector:, color:, from_color: nil, period: nil, cycles: nil, persist: nil, power_on: nil, peak: nil)
        Response.new(
          raw: @connection.post(
            path: "/v1beta1/lights/#{selector}/effects/breathe",
            body: build_body(
              color: color,
              from_color: from_color,
              period: period,
              cycles: cycles,
              persist: persist,
              power_on: power_on,
              peak: peak
            )
          ),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end

      def run_lights_pulse_effect(selector:, color:, from_color: nil, period: nil, cycles: nil, persist: nil, power_on: nil, duty_cycle: nil)
        Response.new(
          raw: @connection.post(
            path: "/v1beta1/lights/#{selector}/effects/pulse",
            body: build_body(
              color: color,
              from_color: from_color,
              period: period,
              cycles: cycles,
              persist: persist,
              power_on: power_on,
              duty_cycle: duty_cycle
            )
          ),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end

      private

      def build_body(params)
        params.reject { |name, value| value.nil? }
      end
    end
  end
end
