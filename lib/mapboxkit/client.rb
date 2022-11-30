# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'mapboxkit/configurable'
require 'mapboxkit/connection'
require 'mapboxkit/client/styles'

module Mapboxkit
  # Client for the Mapbox API
  #
  # @see https://docs.mapbox.com/api/
  class Client
    include Configurable
    include Connection

    include Styles

    def initialize(**options)
      configure do |config|
        options.each do |key, value|
          next unless Configurable::Config::KEYS.include?(key)

          config.public_send(:"#{key}=", value)
        end
      end
    end
  end
end
