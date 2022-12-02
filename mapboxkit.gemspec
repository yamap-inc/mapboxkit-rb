# frozen_string_literal: true

require_relative 'lib/mapboxkit/version'

Gem::Specification.new do |spec|
  spec.name = 'mapboxkit'
  spec.version = Mapboxkit::VERSION
  spec.authors = ['Mizokami Ryutaro']
  spec.email = ['mizokami.ryutaro@yamap.co.jp']
  spec.summary = 'Ruby toolkit for the Mapbox API'
  spec.description = 'Ruby toolkit for the Mapbox API'
  spec.homepage = 'https://github.com/yamap-inc/mapboxkit-rb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yamap-inc/mapboxkit-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/yamap-inc/mapboxkit-rb/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-multipart'

  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
