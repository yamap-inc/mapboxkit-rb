# frozen_string_literal: true

require 'mapboxkit/client'

module Mapboxkit
  class Client
    #
    # Mapbox Styles API
    #
    # https://docs.mapbox.com/api/maps/styles/
    #
    module Styles
      #
      # Retrieve a style
      #
      # https://docs.mapbox.com/api/maps/styles/#retrieve-a-style
      #
      def style(username, style_id, draft: false)
        path = "styles/v1/#{username}/#{style_id}"
        path = "#{path}/draft" if draft

        get(path)
      end

      #
      # List styles
      #
      # https://docs.mapbox.com/api/maps/styles/#list-styles
      #
      def styles(username, options = {})
        get("styles/v1/#{username}", options)
      end

      #
      # Retrieve a style ZIP bundle
      #
      # https://docs.mapbox.com/api/maps/styles/#retrieve-a-style-zip-bundle
      #
      def style_zip_bundle(username, style_id)
        get("styles/v1/#{username}/#{style_id}")
      end

      #
      # Create a style
      #
      # https://docs.mapbox.com/api/maps/styles/#response-create-a-style
      #
      def create_style(username, data)
        post("styles/v1/#{username}", data)
      end

      #
      # Update a style
      #
      # https://docs.mapbox.com/api/maps/styles/#update-a-style
      #
      def update_style(username, style_id, data)
        patch("styles/v1/#{username}/#{style_id}", data)
      end

      # Delete a style
      #
      # https://docs.mapbox.com/api/maps/styles/#delete-a-style
      #
      def delete_style(username, style_id)
        delete("styles/v1/#{username}/#{style_id}", {})
      end

      #
      # Protect a style
      #
      # https://docs.mapbox.com/api/maps/styles/#protect-a-style
      #
      def protect_style(username, style_id, protect)
        put("styles/v1/#{username}/#{style_id}/protected", protect.to_s, content_type: 'text/plain')
      end

      #
      # Request embeddable HTML
      #
      # https://docs.mapbox.com/api/maps/styles/#request-embeddable-html
      #
      def embeddable_html(username, style_id, options = {})
        path = "styles/v1/#{username}/#{style_id}"
        path = "#{path}/draft" if options[:draft]
        path = "#{path}.html"

        # REVIEW: Verify if it works.
        get(path, options)
      end

      #
      # Retrieve a map's WMTS document
      #
      # https://docs.mapbox.com/api/maps/styles/#retrieve-a-maps-wmts-document
      def wmts_document(username, style_id)
        get("styles/v1/#{username}/#{style_id}/wmts")
      end

      #
      # Retrieve a sprite image or JSON
      #
      # https://docs.mapbox.com/api/maps/styles/#retrieve-a-sprite-image-or-json
      #
      def sprite(username, style_id, sprite_id = nil, scale = nil, format = nil)
        path = "styles/v1/#{username}/#{style_id}"
        path = "#{path}/#{sprite_id}" if sprite_id
        path = "#{path}/sprite"
        path = "#{path}@#{scale}" if scale
        path = "#{path}.#{format}" if format

        get(path)
      end

      #
      # Add new image to sprite
      #
      # https://docs.mapbox.com/api/maps/styles/#add-new-image-to-sprite
      #
      def add_image_to_sprite(username, style_id, icon_name, data)
        put("styles/v1/#{username}/#{style_id}/sprite/#{icon_name}", data.read, content_type: 'image/svg+xml')
      end

      #
      # Add multiple new images to sprite
      #
      # https://docs.mapbox.com/api/maps/styles/#add-multiple-new-images-to-sprite
      #
      def add_images_to_sprite(username, style_id, images)
        images = images.map do |image|
          io           = image.fetch(:io)
          filename     = image.fetch(:filename)

          Faraday::Multipart::FilePart.new(io, 'image/svg+xml', filename)
        end

        payload = { images: }

        post("styles/v1/#{username}/#{style_id}/sprite", payload, content_type: 'multipart/form-data')
      end

      #
      # Delete image from sprite
      #
      # https://docs.mapbox.com/api/maps/styles/#delete-image-from-sprite
      #
      def delete_image_from_sprite(username, style_id, icon_name)
        delete("styles/v1/#{username}/#{style_id}/sprite/#{icon_name}", {}, content_type: nil)
      end

      #
      # Delete multiple images from sprite
      #
      # https://docs.mapbox.com/api/maps/styles/#delete-multiple-images-from-sprite
      #
      def delete_images_from_sprite(username, style_id, data)
        delete("styles/v1/#{username}/#{style_id}/sprite", data)
      end
    end
  end
end
