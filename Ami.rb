#!/usr/bin/env ruby

##
# Fichier         : Ami.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe abstraite représente un personnage non joueur ami. 
#  Un personnage non joueur ami est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Une image le représentant
#

require './PNJ.rb'

class Ami < PNJ 
  
   @intitule
  
   private_class_method :new
  
  
   ##
   # Crée un nouvel Ami à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ami
   #
   def initialize(casePosition)
      super(casePosition)
   end
  
  
   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ami
   #
   def Ami.creer(casePosition)
      if(self.class == Ami)
         raise "Subclass responsability"
      end
      return new(casePosition)
   end
  
  
   ##
   # Retourne l'image representant le PNJ Ami.
   #
   def getIntitule()
      return @intitule
   end
  
  
  ##
  # Represente l'interaction avec un element present sur une case (dans ce cas interargir avec un commercant)
  # non définie
  #
  def interaction(joueur)
  end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Ami sur lequel la méthode est appellée.
   #
   def to_s
     s= "Intitule: #{@intitule} | "
     s+= super()
     return s
   end

end