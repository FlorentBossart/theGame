#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeEquipable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de...
#

class BibliothequeTypeEquipable

   @@tableType = Hash.new()

   private_class_method :new
    
   
   ##
   # Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeTypeEquipable.ajouter(cle,type)
      @@tableType[cle] = type
   end
   
   
   ##
   # Retirer un type de la bibliothèque.
   #
   def BibliothequeTypeEquipable.retirer(cle)
      @@tableType.delete(cle)
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
      return valeurs[rand(valeurs.length)-1]
   end

end
