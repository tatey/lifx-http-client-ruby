require 'lifx/http/loader/equatable'

module LIFX
  module HTTP
    module Loader
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
