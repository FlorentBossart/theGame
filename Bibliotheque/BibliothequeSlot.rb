#!/usr/bin/env ruby 

## 
# Fichier        : BibliothequeSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de cr�er une liste contenant les infos d'un slot de sauvegarde. Elle contient donc :
#* Une liste repr�sentant une sauvegarde avec le nom du joueur, sa difficult� ainsi que sa date de derni�re modification
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
   # Retourne la valeur de la cl� fournie en param�tre
   #
   def BibliothequeSlot.getSlot(cle)
      return @@tableSlots[cle]
   end

end

