#!/usr/bin/env ruby

##
# Fichier         : AbstractInterface.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Ce Module permet de creer des interfaces et des classes abstraites
#

module AbstractInterface
  
  class InterfaceNotImplementedError < NoMethodError
  end
  
  def self.included(klass)
    klass.send(:include, AbstractInterface::Methods)
    klass.send(:extend, AbstractInterface::Methods)
  end
  
  module Methods
    
    def api_not_implemented(klass)
      caller.first.match(/in \`(.+)\'/)
      method_name = $1
      raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    end
    
  end
  
end