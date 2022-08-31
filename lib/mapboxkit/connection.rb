# frozen_string_literal: true

require 'mapboxkit/client'

module Mapboxkit
  class Client
    #
    # Network layer for API clients.
    #
    module Connection
      DEFAULT_REQUEST_CONTENT_TYPE = Faraday::Request::Json::MIME_TYPE

      def get(url, params = {})
        response = connection.get(url, params, content_type: nil)

        response.body
      end

      def post(url, params, **kwargs)
        request(:post, url, params, **kwargs)
      end

      def put(url, params, **kwargs)
        request(:put, url, params, **kwargs)
      end

      def patch(url, params, **kwargs)
        request(:patch, url, params, **kwargs)
      end

      def delete(url, params, **kwargs)
        request(:delete, url, params, **kwargs)
      end

      def request(method, url, params, content_type: DEFAULT_REQUEST_CONTENT_TYPE)
        response = connection.public_send(method, url) do |req|
          req.headers[Faraday::CONTENT_TYPE] = content_type

          case content_type
          when 'text/plain', 'image/svg+xml' then req.body = params.to_s
          when 'multipart/form-data' then req.body = params
          end
        end

        response.body
      end

      def connection
        @connection ||= \
          Faraday.new(url: config.url, headers: { 'User-Agent' => config.user_agent }) do |faraday|
            faraday.use(AuthorizationMiddleware, config.access_token)

            faraday.request(:json)

            faraday.request(:multipart, flat_encode: true)

            faraday.response(:logger) if ENV['VERBOSE'] == '1'

            faraday.response(:json)

            faraday.adapter(Faraday.default_adapter)
          end
      end

      #
      # Authorization middleware for the connection
      #
      class AuthorizationMiddleware < Faraday::Middleware
        def initialize(app, access_token)
          @access_token = access_token

          super(app)
        end

        def on_request(env)
          return unless @access_token

          env.url.then do |uri|
            uri.query = [uri.query, "access_token=#{@access_token}"].compact.join('&')
          end
        end
      end
    end
  end
end
