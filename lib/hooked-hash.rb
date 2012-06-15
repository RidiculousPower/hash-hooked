
require 'identifies_as'

class ::Hash::Hooked < ::Hash
end
class ::HookedHash < ::Hash::Hooked
end

basepath = 'hooked-hash/Hash/Hooked'

files = [
    
]

second_basepath = 'hooked-hash/HookedHash'

second_files = [
  
  'Interface'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
second_files.each do |this_file|
  require_relative( File.join( second_basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
require_relative( second_basepath + '.rb' )
