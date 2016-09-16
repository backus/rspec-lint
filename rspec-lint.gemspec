
# frozen_string_literal: true
Gem::Specification.new do |gem|
  gem.name        = 'rspec-lint'
  gem.version     = '0.0.0'
  gem.authors     = ['John Backus']
  gem.email       = ['johncbackus@gmail.com']
  gem.description = 'Lint RSpec'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/backus/rspec-lint'
  gem.license     = 'MIT'

  gem.require_paths = %w[lib]

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split("\n")
  gem.extra_rdoc_files = %w[]
  gem.executables      = %w[rspec-lint]

  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency('rspec', '~> 3.4')
end
