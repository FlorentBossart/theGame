#!/usr/bin/env ruby

##
# Fichier        : TypeMangeable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un type d'objet que l'on peut manger. Un objet mangeable se défini par :
# == Un intitulé unique permettant de le distinguer
# == Une valeur représentant l'énergie que sa consommation apporte au personnage qui le mangera
# == Un cout d'achat/revente (prix)
#



class TypeMangeable

   @intitule
   @energieRendue
   @prix
   @rarete

   attr_reader :intitule, :energieRendue, :prix, :rarete
   
   ##
   # Crée un nouveau TypeTerrain à partir des informations passées en paramètre.
   #
   # == Parameters:
   # intitule : une chaine de caractères correspondant au nom courrament donné au type de nourriture à créer
   # energieRendue : l'énergie que regagnera le personnage en consommant le mangeale
   # prix : le prix à l'achat ou à la revente du mangeable
   #
   def initialize(intitule, energieRendue, prix, rarete)
      @intitule      = intitule
      @energieRendue = energieRendue
      @prix          = prix
      @rarete        = rarete
   end
   
   
   def TypeMangeable.creer(intitule, energieRendue, prix,rarete)
      return new(intitule, energieRendue, prix,rarete)
   end
   
   def description
     s=XmlMultilingueReader.lireTexte("descTypeMangeable")
     s=s.gsub("INTITULE",@intitule).gsub("ENERGIE",@energieRendue.to_s).gsub("PRICE",@prix.to_s)
   end
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeMangeable sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==TypeMangeable >>> | "
      s+= "Intitulé: #{@intitule} | "
      s+= "Energie délivrée: #{@energieRendue} | "
      s+= "Prix: #{@prix} | "
      s+= "<<< TypeMangeable==]"
   end
   
    def getIntitule
       return @intitule
    end
    
    def estEquipable?
       return false
    end

end
