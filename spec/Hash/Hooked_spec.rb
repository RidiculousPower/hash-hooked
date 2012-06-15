
require_relative '../../lib/hooked-hash.rb'

describe ::Hash::Hooked do

  ################
  #  initialize  #
  ################

  it 'can add initialize with an ancestor, inheriting its values and linking to it as a child' do
  
    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.instance_variable_get( :@parent_composite_object ).should == nil
    cascading_composite_hash.should == {}
    cascading_composite_hash[ :A ] = 1
    cascading_composite_hash[ :B ] = 2
    cascading_composite_hash[ :C ] = 3
    cascading_composite_hash[ :D ] = 4
    cascading_composite_hash.should == { :A => 1,
                                         :B => 2,
                                         :C => 3,
                                         :D => 4 }

  end

  #########
  #  []=  #
  #########

  it 'can add elements' do

    cascading_composite_hash = ::Hash::Hooked.new
    
    cascading_composite_hash[ :some_setting ] = :some_value
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash[ :other_setting ] = :some_value
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }

    cascading_composite_hash.method( :[]= ).should == cascading_composite_hash.method( :store )
    
  end

  ############
  #  delete  #
  ############

  it 'can delete elements' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }

    cascading_composite_hash.delete( :some_setting )
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  ###############
  #  delete_if  #
  ###############

  it 'can delete elements with a block' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.delete_if do |key, value|
      key == :some_setting
    end
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  #############
  #  reject!  #
  #############

  it 'can delete elements with a block' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.reject! do |key, value|
      key == :some_setting
    end
    cascading_composite_hash.should == { :other_setting => :some_value }

  end
  
  #############
  #  keep_if  #
  #############

  it 'can keep elements with a block' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.keep_if do |key, value|
      key != :some_setting
    end
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  #############
  #  select!  #
  #############

  it 'can keep elements with a block' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }

    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.select! do |key, value|
      key != :some_setting
    end
    cascading_composite_hash.should == { :other_setting => :some_value }

  end
  
  ############
  #  merge!  #
  #  update  #
  ############
  
  it 'can merge from another hash' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.merge!( :some_setting => :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }
    cascading_composite_hash.merge!( :other_setting => :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }

  end
  
  #############
  #  replace  #
  #############
  
  it 'can replace existing elements with others' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.replace( :some_setting => :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }
    cascading_composite_hash.replace( :other_setting => :some_value )
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  ###########
  #  shift  #
  ###########
  
  it 'can shift the first element' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }
    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.shift
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  ###########
  #  clear  #
  ###########
  
  it 'can clear, causing present elements to be excluded' do

    cascading_composite_hash = ::Hash::Hooked.new

    cascading_composite_hash.store( :some_setting, :some_value )
    cascading_composite_hash.should == { :some_setting => :some_value }
    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :some_setting  => :some_value,
                                         :other_setting => :some_value }
    cascading_composite_hash.clear
    cascading_composite_hash.should == { }
    cascading_composite_hash.store( :other_setting, :some_value )
    cascading_composite_hash.should == { :other_setting => :some_value }

  end

  ##################
  #  pre_set_hook  #
  ##################

  it 'has a hook that is called before setting a value; return value is used in place of object' do
    
    class ::Hash::Hooked::SubMockPreSet < ::Hash::Hooked
      
      def pre_set_hook( key, object, is_insert = false )
        return :some_other_value
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPreSet.new

    cascading_composite_hash[ :some_key ] = :some_value
    
    cascading_composite_hash.should == { :some_key => :some_other_value }
    
  end

  ###################
  #  post_set_hook  #
  ###################

  it 'has a hook that is called after setting a value' do

    class ::Hash::Hooked::SubMockPostSet < ::Hash::Hooked
      
      def post_set_hook( key, object, is_insert = false )
        unless key == :some_other_key
          self[ :some_other_key ] = :some_other_value
        end
        return object
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPostSet.new

    cascading_composite_hash[ :some_key ] = :some_value
    
    cascading_composite_hash.should == { :some_key => :some_value,
                                          :some_other_key => :some_other_value }
    
  end

  ##################
  #  pre_get_hook  #
  ##################

  it 'has a hook that is called before getting a value; if return value is false, get does not occur' do
    
    class ::Hash::Hooked::SubMockPreGet < ::Hash::Hooked
      
      def pre_get_hook( key )
        return false
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPreGet.new
    
    cascading_composite_hash[ :some_key ] = :some_value
    cascading_composite_hash[ :some_key ].should == nil
    
    cascading_composite_hash.should == { :some_key => :some_value }
    
  end

  ###################
  #  post_get_hook  #
  ###################

  it 'has a hook that is called after getting a value' do

    class ::Hash::Hooked::SubMockPostGet < ::Hash::Hooked
      
      def post_get_hook( key, object )
        self[ :some_other_key ] = :some_other_value
        return object
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPostGet.new
    
    cascading_composite_hash[ :some_key ] = :some_value

    cascading_composite_hash.should == { :some_key => :some_value }
    
    cascading_composite_hash[ :some_key ].should == :some_value
    
    cascading_composite_hash.should == { :some_key => :some_value,
                                         :some_other_key => :some_other_value }
    
  end

  #####################
  #  pre_delete_hook  #
  #####################

  it 'has a hook that is called before deleting an key; if return value is false, delete does not occur' do
    
    class ::Hash::Hooked::SubMockPreDelete < ::Hash::Hooked
      
      def pre_delete_hook( key )
        return false
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPreDelete.new
    
    cascading_composite_hash[ :some_key ] = :some_value
    cascading_composite_hash.delete( :some_key )
    
    cascading_composite_hash.should == { :some_key => :some_value }
    
  end

  ######################
  #  post_delete_hook  #
  ######################

  it 'has a hook that is called after deleting an key' do
    
    class ::Hash::Hooked::SubMockPostDelete < ::Hash::Hooked
      
      def post_delete_hook( key, object )
        unless key == :some_other_key
          delete( :some_other_key )
        end
      end
      
    end
    
    cascading_composite_hash = ::Hash::Hooked::SubMockPostDelete.new
    
    cascading_composite_hash[ :some_key ] = :some_value
    cascading_composite_hash[ :some_other_key ] = :some_other_value
    cascading_composite_hash.delete( :some_key )
    
    cascading_composite_hash.should == { }
    
  end

end
