#!/usr/bin/env ruby

##
# Fichier        : Caracteristique.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente une caractéristique(d'item): C'est une classe abstraite.
#

class Caracteristique
    
    private_class_method :new
    
    
    ##
    # Appel de la méthode initialize.
    #
    def Caracteristique.creer()
        if(self.class==Caracteristique)
    raise "Subclass responsability"
        end
        return new()
    end
    
    
    ##
    # (Abstraite) Renvoi la clé pour accèder à l'image dans la table  de RefGraphiques.
    #
    def getIntitule()
    end
    
    
    ##
    # (Abstraite) Fait en sorte que le joueur utilise l'item possédant cette caractéristique.
    #
    # == Parameters:
    # joueur : un objet Joueur corespondant au joueur qui utilise l'item
    #
    def utiliseToi(joueur)
    end
    
    def estEquipable()
        return false
    end
    
    ##
    # (Abstraite) Retourne une chaîne de caractères reprenant les différentes caractéristiques
    # de l'objet Caracteristique sur lequel la méthode est appellée.
    #
    def to_s
    end
    
end
