require 'net/http'
require 'time'
require 'uri'

require 'lifx/http/version'

module LIFX
  module HTTP
    class Error < StandardError; end
    class UnexpectedStatusError < Error; end

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

    class Response
      def initialize(raw:, loader:, expects: [])
        @raw = raw
        @loader = loader
        @expects = expects
      end

      def body
        JSON.parse(@raw.body)
      end

      def object
        return unless success?

        if body.is_a?(Array)
          body.map { |data| @loader.new(data) }
        else
          [@loader.new(body)]
        end
      end

      def headers
        @raw.each_header.to_h
      end

      def status
        @raw.code.to_i
      end

      def success!
        if success?
          self
        else
          raise UnexpectedStatusError, "Expected(#{@expects}) <=> Actual(status)"
        end
      end

      def success?
        @expects.include?(status)
      end
    end

    class Connection
      BASE_URI = URI.parse('https://api.lifx.com')
      USER_AGENT = "LIFX/#{VERSION} Ruby/#{RUBY_VERSION}-#{RUBY_PLATFORM}"

      attr_reader :user_agent

      def initialize(access_token:, base_uri: BASE_URI, user_agent: USER_AGENT)
        @access_token = access_token
        @user_agent = user_agent
        @https = Net::HTTP.new(base_uri.host, base_uri.port)
        @https.use_ssl = true
        @https.open_timeout = 10
        @https.read_timeout = 10
        @https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      def get(path:)
        request = Net::HTTP::Get.new(path)
        perform_request(request)
      end

      def post(path:, body: {})
        request = Net::HTTP::Post.new(path)
        request.body = URI.encode_www_form(body)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        perform_request(request)
      end

      def put(path:, body: {})
        request = Net::HTTP::Put.new(path)
        request.body = URI.encode_www_form(body)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        perform_request(request)
      end

      private

      def perform_request(request)
        request['Accept'] = 'application/json'
        request['Authorization'] = "Bearer #{@access_token}"
        request['User-Agent'] = @user_agent

        @https.request(request)
      end
    end

    module Loader
      module Equatable
        def ==(other)
          other.is_a?(self.class) && other.to_h == to_h
        end
      end

      class Color
        include Equatable

        attr_reader :hue, :saturation, :kelvin

        def initialize(data)
          @hue = data.fetch('hue')
          @saturation = data.fetch('saturation')
          @kelvin = data.fetch('kelvin')
        end

        def to_h
          {
            hue: hue,
            saturation: saturation,
            kelvin: kelvin
          }
        end
      end

      class Device
        include Equatable

        attr_reader :id, :uuid, :label, :connected, :power, :color,
          :brightness, :group, :location, :last_seen, :seconds_since_seen

        def initialize(data)
          @id = data.fetch('id')
          @uuid = data.fetch('uuid')
          @connected = data.fetch('connected')
          @power = data.fetch('power')
          @color = Color.new(data.fetch('color'))
          @brightness = data.fetch('brightness')
          @group = Group.new(data.fetch('group'))
          @location = Location.new(data.fetch('location'))
          @last_seen = Time.parse(data.fetch('last_seen'))
          @seconds_since_seen = data.fetch('seconds_since_seen')
        end

        def connected?
          connected
        end

        def to_h
          {
            id: id,
            uuid: uuid,
            connected: connected,
            power: power,
            color: color.to_h,
            brightness: brightness,
            group: group.to_h,
            location: location.to_h,
            last_seen: last_seen,
            seconds_since_seen: seconds_since_seen,
          }
        end
      end

      class Group
        include Equatable

        attr_reader :id, :name

        def initialize(data)
          @id = data.fetch('id')
          @name = data.fetch('name')
        end

        def to_h
          {
            id: id,
            name: name
          }
        end
      end

      class Location
        include Equatable

        attr_reader :id, :name

        def initialize(data)
          @id = data.fetch('id')
          @name = data.fetch('name')
        end

        def to_h
          {
            id: id,
            name: name
          }
        end
      end

      class Result
        include Equatable

        attr_reader :id, :status

        def initialize(data)
          @id = data.fetch('id')
          @status = data.fetch('status')
        end

        def ok?
          status == 'ok'
        end

        def timed_out?
          status == 'timed_out'
        end

        def offline?
          status == 'offline'
        end

        def to_h
          {
            id: id,
            status: status
          }
        end
      end
    end
  end
end
