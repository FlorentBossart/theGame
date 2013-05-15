#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeEquipable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types d'item équipable définie par:
#* Une table de hachage statique contenant les types d'item équipable (les clés sont des intitulés sous forme de chaine de caractères)
#



class BibliothequeTypeEquipable

   @@tableType = Hash.new()

   private_class_method :new
    
   
   ##
   #===Ajouter un type dans la bibliothèque (écrase si déjà présente).
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type équipable à ajouter
   #* <b>type :</b> le type du type equipable à ajouter
   #
   def BibliothequeTypeEquipable.ajouter(cle,type)
     AffichageDebug.Afficher("Ajout dans BibliothequeTypeEquipable-> clé:#{cle}, type:#{type}")
     @@tableType[cle] = type
     return self
   end
   
   
   ##
   #===Retirer un type de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type équipable à retirer
   #
   def BibliothequeTypeEquipable.retirer(cle)
     AffichageDebug.Afficher("Suppression dans BibliothequeTypeEquipable-> clé:#{cle}")
     @@tableType.delete(cle)
     return self
   end
   
   
   ##
   #===Permet de recuperer un type equipable de la bibliothèque.
   #
   #===Paramètres:
   #* <b>cle :</b> la clé du type equipable souhaitée
   #
   #===Retourne:
   #* <b>TypeEquipable :</b> le type equipable souhaité
   #
   def BibliothequeTypeEquipable.getTypeEquipable(cle)
      return @@tableType[cle]
   end
   
   def BibliothequeTypeEquipable.getTypes()
     return @@tableType.values()
   end
   
   
   ##
   #===Permet de recuperer un type equipable au hasard
   #
   #===Retourne:
   #* <b>TypeEquipable :</b> un type equipable au hasard
   #
   def BibliothequeTypeEquipable.getTypeEquipableAuHasard()
      valeurs=@@tableType.values()
      return valeurs[rand(valeurs.length)]
   end
   
   def BibliothequeTypeEquipable.getTypeEquipableAuHasardRarete(rareteMin,rareteMax)
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

