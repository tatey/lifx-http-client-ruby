require 'lifx/http/loader/equatable'

module LIFX
  module HTTP
    module Loader
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
    end
  end
end
