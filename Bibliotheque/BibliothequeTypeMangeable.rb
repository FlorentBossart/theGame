#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeMangeable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de
#

class BibliothequeTypeMangeable

   @@tabletype = Hash.new()

   private_class_method :new
    
   
   ##
   # Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeTypeMangeable.ajouter(cle,difficulte)
      @@tabletype[cle] = difficulte
   end
   
   
   ##
   # Retirer un type de la bibliothèque.
   #
   def BibliothequeTypeMangeable.retirer(cle)
      @@tabletype.delete(cle)
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeMangeable.getTypeMangeable(cle)
      return @@tabletype[cle]
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeMangeable.getTypeMangeableAuHasard()
      valeurs=@@tabletype.values()
      return valeurs[rand(valeurs.length)-1]
   end

end
