require 'time'
require 'lifx/http/loader/equatable'
require 'lifx/http/loader/color'
require 'lifx/http/loader/group'
require 'lifx/http/loader/location'

module LIFX
  module HTTP
    module Loader
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

        def inspect
          %{#<#{self.class.name} id: "#{id}", uuid: "#{uuid}", label: "#{label}", connected: #{connected}, power: "#{power}", brightness: #{brightness}, color: #{color.inspect}, group: #{group.inspect}, location: #{location.inspect}, last_seen: #{last_seen}, seconds_since_seen: #{seconds_since_seen}>}
        end
      end
    end
  end
end
