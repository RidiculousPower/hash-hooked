
basepath = 'hooked'

files = [

  'hash_interface'
    
]

second_basepath = '../hooked_hash'

second_files = [
  
  'hash_interface'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
second_files.each do |this_file|
  require_relative( File.join( second_basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
require_relative( second_basepath + '.rb' )
