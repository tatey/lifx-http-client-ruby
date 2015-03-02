module LIFX
  module HTTP
    module Loader
      module Equatable
        def ==(other)
          other.is_a?(self.class) && other.to_h == to_h
        end
      end
    end
  end
end
