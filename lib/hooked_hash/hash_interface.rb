
module ::HookedHash::Interface

  instances_identify_as!( ::HookedHash )
  
  ################
  #  initialize  #
  ################

  # Initialize with reference a configuration instance.
  # @param [Object] object Object that HookedHash instance is attached to, primarily useful for
  #  reference from hooks.
  # @param [Hash<Object>] args Parameters passed through super to Hash#initialize.
  # @return [true,false] Whether receiver identifies as object.
  def initialize( configuration_instance = nil, *args )
    
    @configuration_instance = configuration_instance

    super( *args )
        
  end

  ############################
  #  configuration_instance  #
  ############################

  attr_accessor :configuration_instance
  
end
