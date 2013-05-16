#!/usr/bin/env ruby

##
# Fichier        : Personnage.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un Personnage défini par :
# == Une case corespondant à sa position
# C'est une classe abtraite.
#

require './Elem.rb'
require './Enum/EnumDirection.rb'



class Personnage < Elem

  @direction
  
  def Personnage.creer(casePosition)
    new(casePosition)
  end
  def initialize(casePosition)
    super(casePosition)
    @direction=EnumDirection.SUD()
  end
end