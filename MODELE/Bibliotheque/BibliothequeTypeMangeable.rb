#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeMangeable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types d'item mangeable définie par:
#* Une table de hachage statique contenant les types d'item mangeable (les clés sont des intitulés sous forme de chaine de caractères)
#

class BibliothequeTypeMangeable

   @@tableType = Hash.new()

   private_class_method :new
    
   
   ##
   #===Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type mangeable à ajouter
   #* <b>type :</b> le type du type mangeable à ajouter
   #
   def BibliothequeTypeMangeable.ajouter(cle,type)
     AffichageDebug.Afficher("Ajout dans BibliothequeTypeMangeable-> clé:#{cle}, type:#{type}")
     @@tableType[cle] = type
     return self
   end
   
   
   ##
   #===Retirer un type de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type mangeable à retirer
   #
   def BibliothequeTypeMangeable.retirer(cle)
     AffichageDebug.Afficher("Suppression dans BibliothequeTypeMangeable-> clé:#{cle}")
     @@tableType.delete(cle)
     return self
   end
   
   
   ##
   #===Permet de recuperer un type mangeable de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type mangeable souhaité
   #
   #===Retourne:
   #* <b>TypeMangeable :</b> le type mangeable souhaité
   #
   def BibliothequeTypeMangeable.getTypeMangeable(cle)
      return @@tableType[cle]
   end
   
   def BibliothequeTypeMangeable.getTypes()
     return @@tableType.values()
   end
   
   
   ##
   #===Permet de recuperer un type mangeable de la bibliothèque au hasard. 
   #
   #===Retourne:
   #* <b>TypeMangeable :</b> un type mangeable au hasard
   #
   def BibliothequeTypeMangeable.getTypeMangeableAuHasard()
      valeurs=@@tableType.values()
      return valeurs[rand(valeurs.length)]
   end
   
   def BibliothequeTypeMangeable.getTypeMangeableAuHasardRarete(rareteMin,rareteMax)
      valeurs=@@tableType.values()
      valeursPossible=Array.new()
      for v in valeurs
        if(v.rarete<=rareteMax && v.rarete>=rareteMin)
          valeursPossible.push(v)
        end
      end
      return valeursPossible[rand(valeursPossible.length)]
   end

end


