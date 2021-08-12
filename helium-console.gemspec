# frozen_string_literal: true

require_relative 'lib/helium/console/version'

Gem::Specification.new do |spec|
  spec.name          = 'helium-console'
  spec.version       = Helium::Console::VERSION
  spec.authors       = ['Stanislaw Klajn']
  spec.email         = ['sklajn@gmail.com']

  spec.summary       = 'Collection of tools for smooth integration with console'
  spec.homepage      = 'https://github.com/helium-rb/console'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/helium-rb/console'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'colorize'
  spec.add_dependency 'pry'
end
