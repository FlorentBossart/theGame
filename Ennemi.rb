#!/usr/bin/env ruby

##
# Fichier         : Ennemi.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe abstraite représente un personnage non joueur ennemi. 
#  Un personnage non joueur ennemi est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Un type
#* Une energie
#* Un niveau
#

require './PNJ.rb'
require './Type/TypeEnnemi.rb'
require './Enum/EnumDirection.rb'
require './Interface/Deplacable.rb'

class Ennemi < PNJ
   include Deplacable
  
   @type
   @energie
   @niveau
   
   attr_accessor :energie
  
   
   ##
   # Crée un nouvel Ennemi à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ennemi
   #* <b>niveau :</b> le niveau du PNJ Ennemi
   #* <b>type :</b> le type de PNJ Ennemi
   #
   def initialize(casePosition, niveau, type)
      super(casePosition)
      @niveau = niveau
      @type = type
      @energie = @type.energieBase * 1.2
      remplirListeItems()
   end
  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ennemi
   #* <b>niveau :</b> le niveau du PNJ Ennemi
   #* <b>type :</b> le type de PNJ Ennemi
   #
   def Ennemi.creer(casePosition, niveau, type)
      if(self.class == Ennemi)
         raise "Subclass responsability"
      end
      return new(casePosition, niveau, type)
   end
   
   
   ##
   # Permet de remplir aleatoirement la liste d'items.
   #
   def remplirListeItems()
      nbItems = rand(4) + 1
    
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
      
         @listeItem.push(Item.creer(@casePosition, caract))
      end # Fin for
    
      return self
   end
  

   ##
   # Permet de deplacer l'Ennemi sur une cible donnée.
   #
   # == Parameters:
   #* <b>cible :</b> la cible de destination
   #
   def deplacement(cible)
      case cible
         when EnumDirection.NORD
            cible = @casePosition.CaseNord
         when EnumDirection.SUD
            cible = @casePosition.CaseSud
         when EnumDirection.EST
            cible = @casePosition.CaseEst
         else
            cible = @casePosition.CaseOuest
      end
      
      if(!cible.isFull && cible.typeTerrain.isAccessible)
         puts "Deplacement de l'ennemi sur la case " + cible.to_s
         @casePosition.retirerEnnemi(self)
         cible.ajouterEnnemi(self)
         @casePosition = cible
      end
    
      return self
   end
  

   ##
   # Permet de deplacer l'Ennemi sur une cible calculée aleatoirement.
   #
   def deplacementIntelligent()
      cible = rand(3)
    
      case cible
         when 0
            cible = EnumDirection.NORD
            if(!@casePosition.CaseNord.isFull && @casePosition.CaseNord.typeTerrain.isAccessible)
               deplacement(cible)
            end
         when 1
            cible = EnumDirection.SUD
            if(!@casePosition.CaseSud.isFull && @casePosition.CaseSud.typeTerrain.isAccessible)
               deplacement(cible)
            end
         when 2
            cible = EnumDirection.EST
            if(!@casePosition.CaseEst.isFull && @casePosition.CaseEst.typeTerrain.isAccessible)
               deplacement(cible)
            end
         else
            cible = EnumDirection.OUEST
            if(!@casePosition.CaseOuest.isFull && @casePosition.CaseOuest.typeTerrain.isAccessible)
               deplacement(cible)
            end
      end 
   end
  
   
   ##
   # Retourne l'image representant le PNJ Ennemi.
   #
   def representation()
      return @type.intitule
   end
  
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Ennemi sur lequel la méthode est appellée.
   #
   def to_s
      return "[Ennemi Type #{@type} | Energie #{@energie} | Niveau #{@niveau}]"
   end
   
end