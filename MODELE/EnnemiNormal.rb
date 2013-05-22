#!/usr/bin/env ruby

##
# Fichier         : EnnemiNormal.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe représente un personnage non joueur ennemi normal. 
#  Un personnage non joueur ennemi normal est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Un type
#* Une energie
#* Un niveau
#

require 'MODELE/Ennemi.rb'
require 'MODELE/Enum/EnumDirection.rb'

class EnnemiNormal < Ennemi
  
     
   ##
   # Crée un nouvel Ennemi normal à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi normal
   #* <b>niveau :</b> le niveau de l'ennemi normal
   #* <b>type :</b> le type de l'ennemi normal
   #
   def initialize(casePosition, niveau, type,modele)
      super(casePosition, niveau, type,modele)
   end
  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi normal
   #* <b>niveau :</b> le niveau de l'ennemi normal
   #* <b>type :</b> le type de l'ennemi normal
   #
   def EnnemiNormal.creer(casePosition, niveau, type,modele)
      return new(casePosition, niveau, type,modele)
   end
   
  ##
   # Permet de deplacer l'Ennemi sur une cible calculée aleatoirement.
   #
   def deplacementIntelligent()
      cible = rand(3)
    
      case cible
         when 0
            cible = EnumDirection.NORD
            if(!@casePosition.caseNord.isFull?() && @casePosition.caseNord.typeTerrain.isAccessible)
               deplacement(cible)
            else
              deplacement(EnumDirection.SUD)
            end
         when 1
            cible = EnumDirection.SUD
            if(!@casePosition.caseSud.isFull?() && @casePosition.caseSud.typeTerrain.isAccessible)
               deplacement(cible)
              else
                deplacement(EnumDirection.EST)
              end
         when 2
            cible = EnumDirection.EST
            if(!@casePosition.caseEst.isFull?() && @casePosition.caseEst.typeTerrain.isAccessible)
               deplacement(cible)
              else
                deplacement(EnumDirection.OUEST)
              end
         else
            cible = EnumDirection.OUEST
            if(!@casePosition.caseOuest.isFull?() && @casePosition.caseOuest.typeTerrain.isAccessible)
               deplacement(cible)
            end
      end 
   end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet EnnemiNormal sur lequel la méthode est appellée.
   #
   def to_s
     s= "[==EnnemiNormal >>> | "
     s+= super()
     s+= "<<< EnnemiNormal==]"
   end
  
end