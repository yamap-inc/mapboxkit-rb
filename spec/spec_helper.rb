# frozen_string_literal: true

require 'dotenv'

Dotenv.load

require 'mapboxkit'
require 'vcr'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('<MAPBOX_ACCESS_TOKEN>') { ENV.fetch('MAPBOX_ACCESS_TOKEN') }
  config.filter_sensitive_data('<MAPBOX_USERNAME>') { ENV.fetch('MAPBOX_USERNAME') }
  config.default_cassette_options[:record] = :once
end

WebMock.disable_net_connect!
