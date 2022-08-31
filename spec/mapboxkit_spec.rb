# frozen_string_literal: true

RSpec.describe Mapboxkit do
  let(:username) { ENV.fetch('MAPBOX_USERNAME') }

  it do
    expect(Mapboxkit::VERSION).not_to be_nil
  end

  it 'is success', :vcr do
    data = described_class.get('')

    expect(data).to eq('api' => 'mapbox')
  end

  describe '#styles' do
    it 'lists styles', :vcr do
      data = described_class.styles(username)

      aggregate_failures do
        expect(data.size).to eq(2)

        expect(data[0]).to include('version'    => 8,
                                   'name'       => 'Streets',
                                   'id'         => 'cl7h76sxp000715pkomashqt9',
                                   'owner'      => username,
                                   'visibility' => 'private')

        expect(data[1]).to include('version'    => 8,
                                   'name'       => 'Basic',
                                   'id'         => 'cl7h7618q000a14o1guabw90p',
                                   'owner'      => username,
                                   'visibility' => 'public')
      end
    end
  end

  describe '#style' do
    it 'gets a style', :vcr do
      data = described_class.style(username, 'cl7h7618q000a14o1guabw90p')

      expect(data).to include('version'    => 8,
                              'name'       => 'Basic',
                              'id'         => 'cl7h7618q000a14o1guabw90p',
                              'owner'      => username,
                              'visibility' => 'public')
    end
  end

  describe '#create_style' do
    it 'creates a style', :vcr do
      payload = JSON.parse(File.read('./spec/fixtures/styles/basic-v9.json'))

      data = described_class.create_style(username, payload)

      expect(data).to include('version'    => 8,
                              'name'       => 'Basic',
                              'id'         => 'cl7h9b1aw000d16odxowup40w',
                              'owner'      => username,
                              'visibility' => 'private')
    end
  end

  describe '#update_style' do
    it 'update a style', :vcr do
      payload = JSON.parse(File.read('./spec/fixtures/styles/basic-v9.json'))

      payload['name'] = 'New Style Name'

      data = described_class.update_style(username, 'cl7h9b1aw000d16odxowup40w', payload)

      expect(data).to include('name'       => 'New Style Name',
                              'id'         => 'cl7h9b1aw000d16odxowup40w',
                              'owner'      => username,
                              'visibility' => 'private')
    end
  end

  describe '#delete_style' do
    it 'delete a style', :vcr do
      data = described_class.delete_style(username, 'cl7h9b1aw000d16odxowup40w')

      expect(data).to eq('')
    end
  end

  describe '#protect_style' do
    it 'protect a style', :vcr do
      data = described_class.protect_style(username, 'cl7h9b1aw000d16odxowup40w', true)

      expect(data).to eq('protected' => true)
    end

    it 'unprotect a style', :vcr do
      data = described_class.protect_style(username, 'cl7h9b1aw000d16odxowup40w', false)

      expect(data).to eq('protected' => false)
    end
  end

  describe '#embeddable_html' do
    it 'gets an embeddable HTML', :vcr do
      data = described_class.embeddable_html(username, 'cl7h7618q000a14o1guabw90p')

      expect(data).to start_with('<!DOCTYPE html>')
    end
  end

  describe '#wmts_document' do
    it 'gets a WMTS document', :vcr do
      data = described_class.wmts_document(username, 'cl7h7618q000a14o1guabw90p')

      expect(data).to start_with('<Capabilities ')
    end
  end

  describe '#sprite' do
    it 'gets a sprite json', :vcr do
      data = described_class.sprite(username, 'cl7h7618q000a14o1guabw90p')

      expect(data).to be_a(Hash)
    end

    it 'gets a sprite@2x json', :vcr do
      data = described_class.sprite(username, 'cl7h7618q000a14o1guabw90p', nil, '2x')

      expect(data).to be_a(Hash)
    end

    it 'gets a sprite png', :vcr do
      data = described_class.sprite(username, 'cl7h7618q000a14o1guabw90p', nil, nil, 'png')

      expect(data).to be_a(String)
      expect(data[1..3]).to eq('PNG')
    end

    it 'gets a sprite@2x png', :vcr do
      data = described_class.sprite(username, 'cl7h7618q000a14o1guabw90p', nil, '2x', 'png')

      expect(data).to be_a(String)
      expect(data[1..3]).to eq('PNG')
    end
  end

  describe '#add_image_to_sprite' do
    let(:circle_svg) do
      StringIO.new(<<~SVG)
        <svg class="square" width="200" height="200" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.1">
          <circle cx="100" cy="100" r="100" />
        </svg>
      SVG
    end

    it 'add an image to the sprite', :vcr do
      data = described_class.add_image_to_sprite(username, 'cl7h7618q000a14o1guabw90p', 'circle', circle_svg)

      expect(data['circle']['width']).to eq(200)
      expect(data['circle']['height']).to eq(200)
    end
  end

  describe '#add_images_to_sprite' do
    let(:square_svg) do
      StringIO.new(<<~SVG)
        <svg class="square" width="200" height="200" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.1">
          <circle x="0" y="0" width="200" height="100" r="200" />
        </svg>
      SVG
    end

    it 'add an image to the sprite', :vcr do
      images = [{ filename: 'square', io: square_svg }]

      data = described_class.add_images_to_sprite(username, 'cl7h7618q000a14o1guabw90p', images)

      expect(data['square']['width']).to eq(200)
      expect(data['square']['height']).to eq(200)
    end
  end

  describe '#delete_image_from_sprite' do
    it 'delete the image from the sprite', :vcr do
      data = described_class.delete_image_from_sprite(username, 'cl7h7618q000a14o1guabw90p', 'circle')

      expect(data).not_to have_key('circle')
    end
  end

  describe '#delete_images_from_sprite' do
    it 'delete the images from the sprite', :vcr do
      data = described_class.delete_images_from_sprite(username, 'cl7h7618q000a14o1guabw90p', ['square'])

      expect(data).not_to have_key('square')
    end
  end
end
