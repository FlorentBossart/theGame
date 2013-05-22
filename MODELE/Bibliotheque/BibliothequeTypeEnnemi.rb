#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types de terrain définie par:
#* Une table de hachage statique contenant les types de terrain (les clés sont des intitulés sous forme de chaine de caractères)
#

class BibliothequeTypeEnnemi

   @@tableType = Hash.new()

   private_class_method :new
   
   
   ##
   #===Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   #===Paramètres:
   #* <b>cle :</b> la clé de l'ennemi à ajouter
   #* <b>type :</b> le type de l'ennemi à ajouter
   #
   def BibliothequeTypeEnnemi.ajouter(cle,type)
      AffichageDebug.Afficher("Ajout dans BibliothequeTypeEnnemi-> clé:#{cle}, type:#{type}")
      @@tableType[cle] = type
      return self
   end

   
   ##
   #===Retirer un type de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé de l'ennemi à retirer
   #
   def BibliothequeTypeEnnemi.retirer(cle)
      AffichageDebug.Afficher("Suppression dans BibliothequeTypeEnnemi-> clé:#{cle}")
      @@tableType.delete(cle)
      return self
   end

   
   ##
   #===Permet de recuperer un ennemi de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type ennemi souhaité
   #
   #===Retourne:
   #* <b>TypeEnnemi :</b> le type ennemi souhaité
   #
   def BibliothequeTypeEnnemi.getTypeEnnemi(cle)
      return @@tableType[cle]
   end

   
   ##
   #===Permet de recuperer un ennemi de la bibliothèque au hasard
   #
   #===Retourne:
   #* <b>TypeEnnemi :</b> un type ennemi au hasard
   #
   def BibliothequeTypeEnnemi.getTypeEnnemiAuHasard()
      valeurs=@@tableType.values()
      return valeurs[rand(valeurs.length)]
   end

end
