# -*- encoding : utf-8 -*-

basepath = 'hooked'

files = [

  'hash_interface'
    
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
