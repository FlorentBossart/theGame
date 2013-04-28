#!/usr/bin/env ruby

##
# Fichier        : BibliothequeDifficulte.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de...
#

class BibliothequeDifficulte

   @@tableDifficulte = Hash.new()

   private_class_method :new
   
   ##
   # Ajouter une difficulté dans la bibliothèque (écrase si déjà présente).
   #
   def BibliothequeDifficulte.ajouter(cle,difficulte)
      @@tableDifficulte[cle] = difficulte
   end
   
   
   ##
   # Retirer une difficulté de la bibliothèque.
   #
   def BibliothequeDifficulte.retirer(cle)
      @@tableDifficulte.delete(cle)
   end
   
   
   ##
   # 
   #
   def BibliothequeDifficulte.getDifficulte(cle)
      return @@tableDifficulte[cle]
   end
   
   
   ##
   # 
   #
   def BibliothequeDifficulte.getDifficulteAuHasard()
      valeurs = @@tableDifficulte.values()
      return valeurs[rand(valeurs.length)-1]
   end

end
