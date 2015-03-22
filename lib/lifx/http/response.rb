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
        return unless success?

        data = JSON.parse(@raw.body)
        if data.is_a?(Array)
          data.map { |d| @loader.new(d) }
        else
          [@loader.new(data)]
        end
      end
      alias_method :lights, :body
      alias_method :statuses, :body

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

      def inspect
        %{#<#{self.class.name} status: #{status}, body: #{body.inspect}>}
      end
    end
  end
end
