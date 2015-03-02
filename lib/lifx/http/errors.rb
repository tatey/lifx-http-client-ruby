module LIFX
  module HTTP
    class Error < StandardError; end
    class UnexpectedStatusError < Error; end
  end
end
