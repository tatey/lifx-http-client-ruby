require 'net/http'
require 'openssl'
require 'uri'
require 'lifx/http/version'

module LIFX
  module HTTP
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
  end
end
