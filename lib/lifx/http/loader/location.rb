require 'lifx/http/loader/equatable'

module LIFX
  module HTTP
    module Loader
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

        def inspect
          %{#<#{self.class.name} id: "#{id}", name: "#{name}">}
        end
      end
    end
  end
end
