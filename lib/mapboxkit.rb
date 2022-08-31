# frozen_string_literal: true

require_relative 'mapboxkit/version'
require_relative 'mapboxkit/client'

# Ruby toolkit for the Mapbox API
module Mapboxkit
  class Error < StandardError; end

  class << self
    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &)
      if client.respond_to?(method_name)
        client.send(method_name, *args, &)
      else
        super
      end
    end

    def client
      @client ||= Client.new
    end
  end
end
