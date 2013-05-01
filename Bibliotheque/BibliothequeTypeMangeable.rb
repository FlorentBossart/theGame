#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeMangeable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types d'item mangeable définie par:
#* Une table de hachage statique contenant les types d'item mangeable (les clés sont des intitulés sous forme de chaine de caractères)
#

class BibliothequeTypeMangeable

   @@tabletype = Hash.new()

   private_class_method :new
    
   
   ##
   # Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeTypeMangeable.ajouter(cle,type)
     AffichageDebug.Afficher("Ajout dans BibliothequeTypeMangeable-> clé:#{cle}, type:#{type}")
     @@tabletype[cle] = type
     return nil
   end
   
   
   ##
   # Retirer un type de la bibliothèque.
   #
   def BibliothequeTypeMangeable.retirer(cle)
     AffichageDebug.Afficher("Suppression dans BibliothequeTypeMangeable-> clé:#{cle}")
     @@tabletype.delete(cle)
     return nil
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
      return valeurs[rand(valeurs.length-1)]
   end

end
