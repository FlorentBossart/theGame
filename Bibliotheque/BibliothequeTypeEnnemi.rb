#!/usr/bin/env ruby

##
# Fichier        : BibliothequeTypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de...
#

class BibliothequeTypeEnnemi
    
    @@tableType = Hash.new()
    
    private_class_method :new
    
    
    ##
    # Ajouter un type dans la bibliothèque (écrase si déjà présente).
    #
    def BibliothequeTypeEnnemi.ajouter(cle,type)
        @@tableType[cle] = type
    end
    
    
    ##
    # Retirer un type de la bibliothèque.
    #
    def BibliothequeTypeEnnemi.retirer(cle)
        @@tableType.delete(cle)
    end
    
    
    ##
    # 
    #
    def BibliothequeTypeEnnemi.getTypeEnnemi(cle)
        return @@tableType[cle]
    end
    
    
    ##
    # 
    #
    def BibliothequeTypeEnnemi.getTypeEnnemiAuHasard()
        valeurs=@@tableType.values()
        return valeurs[rand(valeurs.length)-1]
    end
    
end
