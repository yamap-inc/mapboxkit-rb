# frozen_string_literal: true

require 'mapboxkit/client'

module Mapboxkit
  #
  # Configuration options the Mapboxkit::Client, defaulting to values
  #
  module Configurable
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end

    #
    # Config for the Mapboxkit::Client
    #
    class Config
      KEYS = %i[url access_token user_agent].freeze

      attr_accessor(*KEYS)

      def initialize
        @url          = 'https://api.mapbox.com'
        @access_token = ENV.fetch('MAPBOX_ACCESS_TOKEN', nil)
        @user_agent   = "Mapboxkit #{Mapboxkit::VERSION}"
      end
    end
  end
end
