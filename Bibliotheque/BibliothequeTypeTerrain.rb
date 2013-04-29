#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la bibliothèque des types de terrain définie par:
#* Une table de hachage statique contenant les types de terrain (les clés sont des intitulés sous forme de chaine de caractères)
#

class BibliothequeTypeTerrain
    
    @@tableType = Hash.new()
    
    private_class_method :new
    
    
    ##
    # Ajouter un type dans la bibliothèque (écrase si déjà présente).
    #
    def BibliothequeTypeTerrain.ajouter(cle,type)
      AffichageDebug.Afficher("Ajout dans BibliothequeTypeTerrain-> clé:#{cle}, type:#{type}")
      @@tableType[cle] = type
      return nil
    end
    
    
    ##
    # Retirer un type de la bibliothèque.
    #
    def BibliothequeTypeTerrain.retirer(cle)
      AffichageDebug.Afficher("Suppression dans BibliothequeTypeTerrain-> clé:#{cle}")
      @@tableType.delete(cle)
      return nil
    end
    
    
    ##
    # 
    #
    def BibliothequeTypeTerrain.getTypeTerrain(cle)
        return @@tableType[cle]
    end
    
    
    ##
    # 
    #
    def BibliothequeTypeTerrain.getTypeTerrainAuHasard()
        valeurs=@@tableType.values()
        return valeurs[rand(valeurs.length-1)]
    end
    
end
