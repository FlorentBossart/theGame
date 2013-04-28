#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de...
#

class BibliothequeTypeTerrain
    
    @@tableType = Hash.new()
    
    private_class_method :new
    
    
    ##
    # Ajouter un type dans la bibliothèque (écrase si déjà présente).
    #
    def BibliothequeTypeTerrain.ajouter(cle,type)
        @@tableType[cle] = type
    end
    
    
    ##
    # Retirer un type de la bibliothèque.
    #
    def BibliothequeTypeTerrain.retirer(cle)
        @@tableType.delete(cle)
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
        return valeurs[rand(valeurs.length)-1]
    end
    
end
