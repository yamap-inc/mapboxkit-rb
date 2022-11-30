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
                                   'id'         => 'clb1k05lh004115lcuz19u71t',
                                   'owner'      => username,
                                   'visibility' => 'public')

        expect(data[1]).to include('version'    => 8,
                                   'name'       => 'Basic',
                                   'id'         => 'clb1jxblw000014tbwhfjxy31',
                                   'owner'      => username,
                                   'visibility' => 'public')
      end
    end
  end

  describe '#style' do
    it 'gets a style', :vcr do
      data = described_class.style(username, 'clb1jxblw000014tbwhfjxy31')

      expect(data).to include('version'    => 8,
                              'name'       => 'Basic',
                              'id'         => 'clb1jxblw000014tbwhfjxy31',
                              'owner'      => username,
                              'visibility' => 'public')
    end
  end

  describe '#create_style' do
    it 'creates a style', :vcr do
      payload = JSON.parse(File.read('./spec/fixtures/styles/my-awesome-style.json'))

      data = described_class.create_style(username, payload)

      expect(data).to include('version'    => 8,
                              'name'       => 'My awesome style',
                              'id'         => 'clb33xfon000b15kxscnf3r90',
                              'owner'      => username,
                              'visibility' => 'private')
    end
  end

  describe '#update_style' do
    it 'update a style', :vcr do
      payload = JSON.parse(File.read('./spec/fixtures/styles/my-awesome-style.json'))

      payload['name'] = 'My new awesome style'

      data = described_class.update_style(username, 'clb33xfon000b15kxscnf3r90', payload)

      expect(data).to include('name'       => 'My new awesome style',
                              'id'         => 'clb33xfon000b15kxscnf3r90',
                              'owner'      => username,
                              'visibility' => 'private')
    end
  end

  describe '#delete_style' do
    it 'delete a style', :vcr do
      data = described_class.delete_style(username, 'clb33xfon000b15kxscnf3r90')

      expect(data).to eq('')
    end
  end

  describe '#protect_style' do
    it 'protect a style', :vcr do
      data = described_class.protect_style(username, 'clb2znpte000214qjisefrjn4', true)

      expect(data).to eq('protected' => true)
    end

    it 'unprotect a style', :vcr do
      data = described_class.protect_style(username, 'clb2znpte000214qjisefrjn4', false)

      expect(data).to eq('protected' => false)
    end
  end

  describe '#embeddable_html' do
    it 'gets an embeddable HTML', :vcr do
      data = described_class.embeddable_html(username, 'clb1jxblw000014tbwhfjxy31')

      expect(data).to start_with('<!DOCTYPE html>')
    end
  end

  describe '#wmts_document' do
    it 'gets a WMTS document', :vcr do
      data = described_class.wmts_document(username, 'clb1jxblw000014tbwhfjxy31')

      expect(data).to start_with('<Capabilities ')
    end
  end

  describe '#sprite' do
    it 'gets a sprite json', :vcr do
      data = described_class.sprite(username, 'clb1jxblw000014tbwhfjxy31')

      expect(data).to be_a(Hash)
    end

    it 'gets a sprite@2x json', :vcr do
      data = described_class.sprite(username, 'clb1jxblw000014tbwhfjxy31', nil, '2x')

      expect(data).to be_a(Hash)
    end

    it 'gets a sprite png', :vcr do
      data = described_class.sprite(username, 'clb1jxblw000014tbwhfjxy31', nil, nil, 'png')

      expect(data).to be_a(String)
      expect(data[1..3]).to eq('PNG')
    end

    it 'gets a sprite@2x png', :vcr do
      data = described_class.sprite(username, 'clb1jxblw000014tbwhfjxy31', nil, '2x', 'png')

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
      data = described_class.add_image_to_sprite(username, 'clb1jxblw000014tbwhfjxy31', 'circle', circle_svg)

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

      data = described_class.add_images_to_sprite(username, 'clb1jxblw000014tbwhfjxy31', images)

      expect(data['square']['width']).to eq(200)
      expect(data['square']['height']).to eq(200)
    end
  end

  describe '#delete_image_from_sprite' do
    let(:circle_svg) do
      StringIO.new(<<~SVG)
        <svg class="square" width="200" height="200" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.1">
          <circle cx="100" cy="100" r="100" />
        </svg>
      SVG
    end

    before do
      # Create circle image
      described_class.add_image_to_sprite(username, 'clb1jxblw000014tbwhfjxy31', 'circle', circle_svg)
    end

    it 'delete the image from the sprite', :vcr do
      data = described_class.delete_image_from_sprite(username, 'clb1jxblw000014tbwhfjxy31', 'circle')

      expect(data).not_to have_key('circle')
    end
  end

  describe '#delete_images_from_sprite' do
    let(:square_svg) do
      StringIO.new(<<~SVG)
        <svg class="square" width="200" height="200" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" version="1.1">
          <circle x="0" y="0" width="200" height="100" r="200" />
        </svg>
      SVG
    end

    before do
      images = [{ filename: 'square', io: square_svg }]

      # Create square image
      described_class.add_images_to_sprite(username, 'clb1jxblw000014tbwhfjxy31', images)
    end

    it 'delete the images from the sprite', :vcr do
      data = described_class.delete_images_from_sprite(username, 'clb1jxblw000014tbwhfjxy31', ['square'])

      expect(data).not_to have_key('square')
    end
  end
end
