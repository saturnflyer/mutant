# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = 'mutant'
  gem.version     = '0.3.0'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'Mutation testing for ruby'
  gem.summary     = 'Mutation testing tool for ruby under MRI and Rubinius'
  gem.homepage    = 'https://github.com/mbj/mutant'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")
  gem.extra_rdoc_files = %w[TODO LICENSE]
  gem.executables       = [ 'mutant' ]

  gem.add_runtime_dependency('backports',           [ '~> 3.0', '>= 3.0.3' ])

  gem.add_runtime_dependency('parser',              '~> 2.0.beta3')
  gem.add_runtime_dependency('unparser',            '~> 0.0.1')
  gem.add_runtime_dependency('ice_nine',            '~> 0.7.0')
  gem.add_runtime_dependency('descendants_tracker', '~> 0.0.1')
  gem.add_runtime_dependency('adamantium',          '~> 0.0.7')
  gem.add_runtime_dependency('equalizer',           '~> 0.0.5')
  gem.add_runtime_dependency('inflecto',            '~> 0.0.2')
  gem.add_runtime_dependency('anima',               '~> 0.0.6')
  gem.add_runtime_dependency('concord',             '~> 0.1.1')
  gem.add_runtime_dependency('rspec',               '~> 2.13.0')
end
