#!/usr/bin/env ruby

##
# Fichier        : Mangeable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la caractéristique mangeable définie par :
# == Un type d'objet mangeable
#

require 'MODELE/Caracteristique.rb'
require 'MODELE/Type/TypeMangeable.rb'
require 'MODELE/Joueur.rb'

class Mangeable < Caracteristique
    
    @typeMangeable
    
    attr_reader :typeMangeable
    
    
    def initialize(typeMangeable)
       super()
       @typeMangeable=typeMangeable
    end
    
    
    def Mangeable.creer(typeMangeable)
        new(typeMangeable)
    end
    
    ##
    # Renvoi la clé pour accèder à l'image dans la table  de RefGraphiques.
    #
    def getIntitule()
        return typeMangeable.intitule
    end
    
    def prix
      return @typeMangeable.prix
    end
    def utiliseToi(joueur)
        if((joueur.energie+typeMangeable.energieRendue)>=joueur.energieMax)
            joueur.energie=joueur.energieMax
        else
            joueur.energie=joueur.energie+typeMangeable.energieRendue
        end
      str=XmlMultilingueReader.lireTexte("repas")
      str=str.gsub("REPAS",XmlMultilingueReader.lireDeterminant_Nom(self))
      joueur.modele.notifier(str)
    end
    
    
    ##
    # Retourne une chaîne de caractères reprenant les différentes caractéristiques
    # de l'objet Mangeable sur lequel la méthode est appellée.
    #
    def to_s
      return @typeMangeable.description
        #s= "[==Mangeable >>> | "
        #s+= "Type=: #{@typeMangeable} | "
        #s+= "<<< Mangeable==]"
  end
    
end