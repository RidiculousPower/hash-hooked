
module ::Hash::Hooked::HashInterface
  
  include ::IdentifiesAs
  
  instances_identify_as!( ::Hash::Hooked )

  ################
  #  initialize  #
  ################

  ###
  # Initialize with reference a configuration instance.
  #
  # @overload initialize( configuration_instance, hash_initialization_arg, ... )
  #
  #   @param [Object] configuration_instance 
  #   
  #          Object that instance will be attached to; primarily useful for reference from hooks.
  #   
  #   @param [Object] hash_initialization_arg
  #   
  #          Parameters passed through super to Hash#initialize.
  #
  def initialize( configuration_instance = nil, default_value = nil, & default_value_block )
    
    @configuration_instance = configuration_instance
    
    if default_value
      super( default_value )
    elsif default_value_block
      super( & default_value_block )
    else
      super()
    end
        
  end

  ############################
  #  configuration_instance  #
  ############################

  ###
  # @!attribute [r]
  #
  # @return [Object]
  #
  #         Object that instance is attached to; primarily useful for reference from hooks.
  #
  attr_accessor :configuration_instance
  
  ######################################  Subclass Hooks  ##########################################

  ##################
  #  pre_set_hook  #
  ##################

  ###
  # A hook that is called before setting a value; return value is used in place of object.
  #
  # @param [Object] key 
  #
  #        Key where object is to be stored.
  #
  # @param [Object] object 
  #
  #        Element being stored.
  #
  # @return [true,false] 
  #
  #         Return value is used in place of object.
  #
  def pre_set_hook( key, object )
    
    return object
    
  end

  ###################
  #  post_set_hook  #
  ###################

  ###
  # A hook that is called after setting a value.
  #
  # @param [Object] key 
  #
  #        Key where object is to be stored.
  #
  # @param [Object] object 
  #
  #        Element being stored.
  #
  # @return [Object] 
  #
  #         Ignored.
  #
  def post_set_hook( key, object )

    return object
    
  end

  ##################
  #  pre_get_hook  #
  ##################

  ###
  # A hook that is called before getting a value; if return value is false, get does not occur.
  #
  # @param [Object] key 
  #
  #        Key where object is to be retrieved.
  #
  # @return [true,false] 
  #
  #         If return value is false, get does not occur.
  #
  def pre_get_hook( key )
    
    return true
    
  end

  ###################
  #  post_get_hook  #
  ###################

  ###
  # A hook that is called after getting a value.
  #
  # @param [Object] key 
  #
  #        Key where object has been retrieved.
  #
  # @param [Object] object 
  #
  #        Element retrieved.
  #
  # @return [Object] 
  #
  #         Object returned in place of get result.
  #
  def post_get_hook( key, object )
    
    return object
    
  end

  #####################
  #  pre_delete_hook  #
  #####################

  ###
  # A hook that is called before deleting a value; if return value is false, delete does not occur.
  #
  # @param [Object] key 
  #
  #        Key where object is to be deleted.
  #
  # @return [true,false] 
  #
  #         If return value is false, delete does not occur.
  #
  def pre_delete_hook( key )
    
    return true
    
  end

  ######################
  #  post_delete_hook  #
  ######################

  ###
  # A hook that is called after deleting a value.
  #
  # @param [Object] key 
  #
  #        Key where object has been deleted.
  #
  # @param [Object] object 
  #
  #        Element deleted.
  #
  # @return [Object] 
  #
  #         Object returned in place of delete result.
  #
  def post_delete_hook( key, object )
    
    return object
    
  end

  #####################################  Self Management  ##########################################

  ########
  #  []  #
  ########

  def []( key )

    object = nil
    
    if @without_hooks
      pre_get_hook_result = true
    else
      pre_get_hook_result = pre_get_hook( key )
    end
    
    if pre_get_hook_result
    
      object = super( key )
      
      unless @without_hooks
        object = post_get_hook( key, object )
      end
      
    end
      
    return object
    
  end

  #######################
  #  get_without_hooks  #
  #######################

  ###
  # Alias to #[] that bypasses hooks.
  #
  # @param [Object] key 
  #
  #        Key where object is to be stored.
  #
  # @return [Object] 
  #
  #         Object retrieved.
  #
  def get_without_hooks( key )
    
    @without_hooks = true
    
    object = self[ key ]
    
    @without_hooks = false
    
    return object
    
  end
  
  #########
  #  []=  #
  #########
  
  def []=( key, object )
    
    unless @without_hooks
      object = pre_set_hook( key, object )
    end
    
    perform_set_between_hooks( key, object )

    unless @without_hooks
      object = post_set_hook( key, object )
    end
    
    return object

  end
  
  alias_method :store, :[]=

  #########################
  #  store_without_hooks  #
  #########################

  ###
  # Alias to #[]= that bypasses hooks.
  #
  # @param [Object] key 
  #
  #        Key where object is to be stored.
  #
  # @param [Object] object 
  #
  #        Element being stored.
  #
  # @return [Object] 
  #
  #         Element returned.
  #
  def store_without_hooks( key, object )
    
    @without_hooks = true
    
    self[ key ] = object
    
    @without_hooks = false
    
    return object
    
  end

  ############
  #  delete  #
  ############
  
  def delete( key )

    object = nil
    
    if @without_hooks
      pre_delete_result = true
    else
      pre_delete_result = pre_delete_hook( key )
    end
    
    if pre_delete_result
    
      object = perform_delete_between_hooks( key )
      
      unless @without_hooks
        object = post_delete_hook( key, object )
      end
      
    end
    
    return object

  end

  ##########################
  #  delete_without_hooks  #
  ##########################

  ###
  # Alias to #delete that bypasses hooks.
  #
  # @param [Object] object 
  #
  #        Element being deleted.
  #
  # @return [Object] 
  #
  #         Element returned.
  #
  def delete_without_hooks( key )
    
    @without_hooks = true
    
    object = delete( key )
    
    @without_hooks = false
    
    return object
    
  end

  ###############
  #  delete_if  #
  ###############

  def delete_if

    return to_enum unless block_given?

    indexes = [ ]
    
    self.each do |this_key, this_object|
      if yield( this_key, this_object )
        delete( this_key )
      end
    end
        
    return self

  end

  #############################
  #  delete_if_without_hooks  #
  #############################

  ###
  # Alias to #delete_if that bypasses hooks.
  #
  # @yield 
  #
  #         Block passed to :delete_if.
  #
  # @return [Object]
  #
  #         Deleted element.
  #
  def delete_if_without_hooks( & block )
    
    @without_hooks = true
    
    delete_if( & block )
    
    @without_hooks = false
    
  end

  #############
  #  reject!  #
  #############

  def reject!

    return to_enum unless block_given?
    
    return_value = nil
    
    self.each do |this_key, this_object|
      if yield( this_key, this_object )
        delete( this_key )
        return_value = self
      end
    end
    
    return return_value

  end

  ###########################
  #  reject_without_hooks!  #
  ###########################

  ###
  # Alias to #reject that bypasses hooks.
  #
  # @yield 
  #
  #         Block passed to :keep_if.
  #
  # @return [Object] 
  #
  #         Self.
  #
  def reject_without_hooks!
    
    @without_hooks = true
    
    return_value = reject!( & block )
    
    @without_hooks = false
    
    return return_value
    
  end

  #############
  #  keep_if  #
  #############

  def keep_if

    return to_enum unless block_given?

    indexes = [ ]
    
    self.each do |this_key, this_object|
      unless yield( this_key, this_object )
        delete( this_key )
      end
    end
        
    return self


  end
  
  ###########################
  #  keep_if_without_hooks  #
  ###########################

  ###
  # Alias to #keep_if that bypasses hooks.
  #
  # @yield 
  #
  #         Block passed to :keep_if.
  #
  # @return [Object] 
  #
  #         Deleted element.
  #
  def keep_if_without_hooks( & block )
    
    @without_hooks = true
    
    keep_if( & block )
    
    @without_hooks = false
    
    return self
    
  end
  
  #############
  #  select!  #
  #############

  def select!

    return to_enum unless block_given?
    
    return_value = nil
    
    self.each do |this_key, this_object|
      unless yield( this_key, this_object )
        delete( this_key )
        return_value = self
      end
    end
    
    return return_value

  end

  ###########################
  #  select_without_hooks!  #
  ###########################

  ###
  # Alias to #select that bypasses hooks.
  #
  # @yield 
  #
  #         Block passed to :select!.
  #
  # @return [Object] 
  #
  #         Self.
  #
  def select_without_hooks!( & block )
    
    @without_hooks = true
    
    return_value = select!( & block )
    
    @without_hooks = false
    
    return return_value
    
  end

  ############
  #  merge!  #
  #  update  #
  ############

  def merge!( other_hash )

    other_hash.each do |this_key, this_object|
      if @compositing_proc
        self[ this_key ] = @compositing_proc.call( self, this_key, this_object )
      else
        self[ this_key ] = this_object
      end
    end

    return self

  end

  alias_method :update, :merge!
  
  ##########################
  #  merge_without_hooks!  #
  #  update_without_hooks  #
  ##########################

  ###
  # Alias to #merge! that bypasses hooks.
  #
  # @return [Object] 
  #
  #         Self.
  #
  def merge_without_hooks!
    
    @without_hooks = true
    
    merge!( other_hash )
    
    @without_hooks = false
    
    return self
    
  end
  
  alias_method :update_without_hooks, :merge_without_hooks!
  
  #############
  #  replace  #
  #############
  
  def replace( other_hash )

    # clear current values
    clear

    # merge replacement settings
    merge!( other_hash )

    return self

  end

  ###########################
  #  replace_without_hooks  #
  ###########################

  ###
  # Alias to #replace that bypasses hooks.
  #
  # @param [Array] other_hash 
  #
  #        Other hash to replace self with.
  #
  # @return [Object] 
  #
  #         Self.
  #
  def replace_without_hooks( other_hash )
    
    @without_hooks = true
    
    replace( other_hash )
    
    @without_hooks = false
    
  end

  ###########
  #  shift  #
  ###########
  
  def shift
    
    object = nil
    
    unless empty?
      last_key = first[ 0 ]
      object = delete( last_key )
    end    

    return [ last_key, object ]

  end

  #########################
  #  shift_without_hooks  #
  #########################

  ###
  # Alias to #shift that bypasses hooks.
  #
  # @return [Object] 
  #
  #         Element shifted.
  #
  def shift_without_hooks
    
    @without_hooks = true
    
    object = shift
    
    @without_hooks = false
    
    return object
    
  end

  ###########
  #  clear  #
  ###########
  
  def clear
    
    delete_if { true }

    return self

  end
  
  #########################
  #  clear_without_hooks  #
  #########################

  ###
  # Alias to #clear that bypasses hooks.
  #
  # @return [Object] 
  #
  #         Self.
  #
  def clear_without_hooks
    
    @without_hooks = true
    
    clear
    
    @without_hooks = false
    
    return self
    
  end
  
end
