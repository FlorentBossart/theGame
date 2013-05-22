#!/usr/bin/env ruby 

## 
# Fichier        : BibliothequeSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de créer un tableau de hashage contenant les infos des slots de sauvegarde. Elle contient donc :
#* Un tableau de hashage représentant chaque sauvegarde avec en clé le nom du fichier du slot de sauvegarde et en valeur, le slot en lui même.
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
   # Retourne la valeur de la clé (nom fichier slotX.yaml) fournie en paramètre
   #
   def BibliothequeSlot.getSlot(cle)
      return @@tableSlots[cle]
   end

end

