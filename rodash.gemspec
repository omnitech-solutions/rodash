# frozen_string_literal: true

require File.expand_path('../lib/rodash/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Desmond O'Leary"]
  gem.email = ["desoleary@gmail.com"]
  gem.description = %q{Lodash inspired utilities}
  gem.summary = %q{Lodash inspired utilities}
  gem.homepage = "https://github.com/omnitech-solutions/rodash"
  gem.license = "MIT"

  gem.files = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^exe/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|features)/})
  gem.name = "light-service-ext"
  gem.require_paths = ["lib"]
  gem.version = Rodash::VERSION
  gem.required_ruby_version = ">= 2.6.0"

  gem.metadata["homepage_uri"] = gem.homepage
  gem.metadata["source_code_uri"] = gem.homepage
  gem.metadata["changelog_uri"] = "#{gem.homepage}/CHANGELOG.md"

  gem.add_runtime_dependency 'stackprof', '>= 0.2'
  gem.add_runtime_dependency 'colorize', '~> 0.8.1'
  gem.add_runtime_dependency 'mime-types', '>= 3'
  gem.add_runtime_dependency 'activesupport', '>= 5'
  gem.add_runtime_dependency 'activestorage', '>= 5'
  gem.add_runtime_dependency 'rack', '>= 2'
  gem.add_runtime_dependency 'faker', '>= 2'
  gem.add_runtime_dependency 'oj', '>= 3'
  gem.add_runtime_dependency 'rudash', '>= 4'
  gem.add_runtime_dependency 'dottie', '>= 0.0.2'
  gem.add_runtime_dependency 'addressable', '>= 2.6.0'
  gem.add_runtime_dependency 'measured', '>= 2.5'

  gem.add_development_dependency("rake", "~> 13.0.6")
  gem.add_development_dependency("rspec", "~> 3.12.0")
  gem.add_development_dependency("simplecov", "~> 0.21.2")
  gem.add_development_dependency("codecov", "~> 0.6.0")
end
