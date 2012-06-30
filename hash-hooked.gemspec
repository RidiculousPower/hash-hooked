require 'date'

Gem::Specification.new do |spec|

  spec.name                      =  'hash-hooked'
  spec.rubyforge_project         =  'hash-hooked'
  spec.version                   =  '1.0.0'

  spec.summary                   =  "Provides ::Hash::Hooked and ::HookedHash."
  spec.description               =  "A subclass of Hash that offers event hooks for pre-set/pre-delete, set/delete. ::HookedHash offers implicit reference to a configuration instance."

  spec.authors                   =  [ 'Asher' ]
  spec.email                     =  'asher@ridiculouspower.com'
  spec.homepage                  =  'http://rubygems.org/gems/hash-hooked'

  spec.add_dependency            'identifies_as'

  spec.date                      = Date.today.to_s
  
  spec.files                     = Dir[ '{lib,spec}/**/*',
                                        'README*', 
                                        'LICENSE*',
                                        'CHANGELOG*' ]

end
