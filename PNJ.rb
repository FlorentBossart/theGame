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

require './Personnage.rb'

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
      @listeItem = Array.new
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
   
  ##
  # Permet de remplir aleatoirement la liste d'items.
  #
  def remplirListeItems(min,max)
     nbItems = rand(max-min) + min
   
     for i in 1..nbItems
        # Choix du type
        type = rand(2)
     
        case type
           when 0 # TypeEquipable
              type = BibliothequeTypeEquipable.getTypeEquipableAuHasard()
              caract = Equipable.creer(type)
           else # TypeMangeable
              type = BibliothequeTypeMangeable.getTypeMangeableAuHasard()
              caract = Mangeable.creer(type)
        end # Fin case type
     
        @listeItem.push(Item.creer(nil, caract))
     end # Fin for
   
     return self
  end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet PNJ sur lequel la méthode est appellée.
   #
   def to_s
      s= super()
      s+= "Items: "
      if(@listeItem.empty?)
        s+= "aucun "
      end
      for i in @listeItem
        s+= "#{i}, "
      end
      s+="| "
      return s
   end
  
end