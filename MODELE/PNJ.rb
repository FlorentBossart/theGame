#!/usr/bin/env ruby

##
# Fichier         : PNJ.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe abstraite représente un PNJ. 
#  Un PNJ est défini par :
#* Une case où il se situe
#* Une liste d'items
#

require 'MODELE/Personnage.rb'

class PNJ < Personnage
  
   @listeItem
  
   attr_accessor :listeItem
   
   private_class_method :new
   
  
   ##
   # Crée un nouveau PNJ à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ
   #
   def initialize(casePosition)
      super(casePosition)
   end
  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ
   #
   def PNJ.creer(casePosition)
      if(self.class == PNJ)
         raise "Subclass responsability"
      end
      return new(casePosition)
   end
  
end