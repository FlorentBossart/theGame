#!/usr/bin/env ruby

##
# Fichier        : BibliothequeDifficulte.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des difficultés définie par:
#* Une table de hachage statique contenant les difficultés (les clés sont des intitulés sous forme de chaine de caractères)
#

require './AffichageDebug.rb'

class BibliothequeDifficulte

   @@tableDifficulte = Hash.new()

   private_class_method :new

      
   ##
   #===Ajouter une difficulté dans la bibliothèque (écrase si déjà présente).
   #
   #===Paramètres:
   #* <b>cle :</b> la clé de la difficulté à ajouter
   #* <b>difficulte :</b> la difficulté
   # 
   def BibliothequeDifficulte.ajouter(cle,difficulte)
      AffichageDebug.Afficher("Ajout dans BibliothequeDifficulte-> clé:#{cle}, Difficulte:#{difficulte}")
      @@tableDifficulte[cle] = difficulte
      return self
   end

   
   ##
   #===Retirer une difficulté de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé de la difficulté à retirer
   #
   def BibliothequeDifficulte.retirer(cle)
      AffichageDebug.Afficher("Suppression dans BibliothequeDifficulte-> clé:#{cle}")
      @@tableDifficulte.delete(cle)
      return self
   end

   
   ##
   #===Permet de recuperer une difficulté de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé de la difficulté souhaitée
   #
   #===Retourne:
   #* <b>difficulte :</b> la difficulté souhaitée
   #
   def BibliothequeDifficulte.getDifficulte(cle)
      return @@tableDifficulte[cle]
   end

   
   ##
   #===Permet de recupérer une difficulté de la bibliothèque au hasard
   #
   #===Retourne:
   #* <b>difficulte :</b> une difficulté au hasard
   #
   def BibliothequeDifficulte.getDifficulteAuHasard()
      valeurs = @@tableDifficulte.values()
      return valeurs[rand(valeurs.length-1)]
   end

end
