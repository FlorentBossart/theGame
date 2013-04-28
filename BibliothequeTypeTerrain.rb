#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de
#

class BibliothequeTypeTerrain

   @@tabletype = Hash.new()

   private_class_method :new
    
   
   ##
   # Ajouter un type de terrain dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeTypeTerrain.ajouter(cle,difficulte)
      @@tabletype[cle] = difficulte
   end
   
   
   ##
   # Retirer un type de terrain de la bibliothèque.
   #
   def BibliothequeTypeTerrain.retirer(cle)
      @@tabletype.delete(cle)
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeTerrain.getTypeTerrain(cle)
      return @@tabletype[cle]
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeTerrain.getTypeTerrainAuHasard()
      valeurs=@@tabletype.values()
      return valeurs[rand(valeurs.length)-1]
   end

end



