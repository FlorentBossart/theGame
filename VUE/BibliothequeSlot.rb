#!/usr/bin/env ruby 

## 
# Fichier        : BibliothequeSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de cr�er un tableau de hashage contenant les infos des slots de sauvegarde. Elle contient donc :
#* Un tableau de hashage repr�sentant chaque sauvegarde avec en cl� le nom du fichier du slot de sauvegarde et en valeur, le slot en lui m�me.
#


class BibliothequeSlot

   @@tableSlots = Hash.new()

   private_class_method :new
   
   ##
   # Ajouter un slot dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeSlot.ajouter(cle,slot)
      @@tableSlots[cle] = slot
   end
   
   
   ##
   # Retirer un slot de la bibliothèque.
   #
   def BibliothequeSlot.retirer(cle)
      @@tableSlots.delete(cle)
   end
   
   
   ##
   # Retourne la valeur de la cl� (nom fichier slotX.yaml) fournie en param�tre
   #
   def BibliothequeSlot.getSlot(cle)
      return @@tableSlots[cle]
   end

end

