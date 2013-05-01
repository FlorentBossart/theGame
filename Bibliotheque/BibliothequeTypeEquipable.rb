#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeEquipable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types d'item équipable définie par:
#* Une table de hachage statique contenant les types d'item équipable (les clés sont des intitulés sous forme de chaine de caractères)
#

class BibliothequeTypeEquipable

   @@tableType = Hash.new()

   private_class_method :new
    
   
   ##
   # Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeTypeEquipable.ajouter(cle,type)
     AffichageDebug.Afficher("Ajout dans BibliothequeTypeEquipable-> clé:#{cle}, type:#{type}")
     @@tableType[cle] = type
     return nil
   end
   
   
   ##
   # Retirer un type de la bibliothèque.
   #
   def BibliothequeTypeEquipable.retirer(cle)
     AffichageDebug.Afficher("Suppression dans BibliothequeTypeEquipable-> clé:#{cle}")
     @@tableType.delete(cle)
     return nil
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeEquipable.getTypeEquipable(cle)
      return @@tableType[cle]
   end
   
   
   ##
   # 
   #
   def BibliothequeTypeEquipable.getTypeEquipableAuHasard()
      valeurs=@@tableType.values()
      return valeurs[rand(valeurs.length-1)]
   end

end
