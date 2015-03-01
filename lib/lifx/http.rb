require 'net/http'
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

      def get_lights(selector: 'all')
        Response.new(
          raw: @connection.get("/v1beta1/lights/#{selector}"),
          loader: Loader::Device,
          expects: [200]
        )
      end

      def post_toggle(selector:, state:)
        Response.new(
          raw: @connection.post("/v1beta1/lights/#{selector}/toggle", {
            body: {state: state}
          }),
          loader: Loader::Result,
          expects: [201, 207]
        )
      end
    end

    class Response
      def initialize(raw:, loader:, expects: [])
        @raw = raw
        @loader = loader
        @expects = expects
      end

      def body
        JSON.parse(body)
      end

      def object
        return unless success?

        if body.is_a?(Array)
          body.map { |item| @loader.load(item) }
        else
          @loader.load(body)
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

      def initialize(access_token:, base_uri: BASE_URI, user_agent: USER_AGENT)
        @access_token = access_token
        @user_agent = user_agent
        @https = Net::HTTP.new(base_uri.host, base_uri.port)
        @https.use_ssl = true
        @https.open_timeout = 10
        @https.read_timeout = 10
        @https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end

      def get(path)
        request = Net::HTTP::Get.new(path)
        perform_request(request)
      end

      def post(path, body: {})
        request = Net::HTTP::Post.new(path)
        request.body = URI.encode_www_form(body)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        perform_request(request)
      end

      def put(path, body: {})
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
      class Device
        def self.load(data)
        end
      end

      class Result
        attr_reader :id, :status

        def initialize(id:, status:)
        end

        def to_h
          {
            id: id,
            status: status
          }
        end

        def self.load(data)
          new(
            id: data.fetch('id'),
            status: data.fetch('status')
          )
        end
      end
    end
  end
end
