require 'json'
require 'lifx/http/errors'

module LIFX
  module HTTP
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
  end
end
