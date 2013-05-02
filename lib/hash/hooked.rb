# -*- encoding : utf-8 -*-

require 'identifies_as'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

class ::Hash::Hooked < ::Hash

  # Alias to original :[]= method. Used to perform actual set between hooks.
  # @param [Object] key Key where object is to be stored.
  # @param [Object] object Element being stored.
  # @return [Object] Element returned.
  alias_method :perform_set_between_hooks, :store

  # Alias to original :delete method. Used to perform actual delete between hooks.
  # @param [Object] key Key where object is to be stored.
  # @return [Object] Element returned.
  alias_method :perform_delete_between_hooks, :delete

  # Alias to original :merge method. Used to perform actual merge between hooks.
  # @return [Object] Self.
  alias_method :perform_merge_between_hooks!, :merge!

  include ::Hash::Hooked::HashInterface
  
end
