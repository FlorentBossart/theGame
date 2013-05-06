#!/usr/bin/env ruby 

## 
# Fichier        : BibliothequeSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de créer une liste contenant les infos d'un slot de sauvegarde. Elle contient donc :
#* Une liste représentant une sauvegarde avec le nom du joueur, sa difficulté ainsi que sa date de dernière modification
#


class BibliothequeSlot

   @@tableSlots = Hash.new()

   private_class_method :new
   
   ##
   # Ajouter un slot dans la bibliothÃ¨que (Ã©crase si dÃ©jÃ  prÃ©sente).
   #
   def BibliothequeSlot.ajouter(cle,slot)
      @@tableSlots[cle] = slot
   end
   
   
   ##
   # Retirer un slot de la bibliothÃ¨que.
   #
   def BibliothequeSlot.retirer(cle)
      @@tableSlots.delete(cle)
   end
   
   
   ##
   # Retourne la valeur de la clé fournie en paramètre
   #
   def BibliothequeSlot.getSlot(cle)
      return @@tableSlots[cle]
   end

end

