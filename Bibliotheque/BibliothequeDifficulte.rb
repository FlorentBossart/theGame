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
  # Ajouter une difficulté dans la bibliothèque (écrase si déjà présente).
  #
  def BibliothequeDifficulte.ajouter(cle,difficulte)
    AffichageDebug.Afficher("Ajout dans BibliothequeDifficulte-> clé:#{cle}, Difficulte:#{difficulte}")
    @@tableDifficulte[cle] = difficulte
    return nil
  end
   
   
  ##
  # Retirer une difficulté de la bibliothèque.
  #
  def BibliothequeDifficulte.retirer(cle)
    AffichageDebug.Afficher("Suppression dans BibliothequeDifficulte-> clé:#{cle}")
    @@tableDifficulte.delete(cle)
    return nil
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
    return valeurs[rand(valeurs.length-1)]
  end

end
