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

require './Ennemi.rb'
require './Enum/EnumDirection.rb'

class EnnemiNormal < Ennemi
  
     
   ##
   # Crée un nouvel Ennemi normal à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi normal
   #* <b>niveau :</b> le niveau de l'ennemi normal
   #* <b>type :</b> le type de l'ennemi normal
   #
   def initialize(casePosition, niveau, type)
      super(casePosition, niveau, type)
   end
  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi normal
   #* <b>niveau :</b> le niveau de l'ennemi normal
   #* <b>type :</b> le type de l'ennemi normal
   #
   def EnnemiNormal.creer(casePosition, niveau, type)
      return new(casePosition, niveau, type)
   end
   
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet EnnemiNormal sur lequel la méthode est appellée.
   #
   def to_s
      return "[EnnemiNormal Type #{@type} | Energie #{@energie} | Niveau #{@niveau}]"
   end
  
end