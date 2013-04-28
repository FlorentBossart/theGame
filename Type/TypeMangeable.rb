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

   attr_reader :intitule, :energieRendue, :prix
   ##
   # Crée un nouveau TypeTerrain à partir des informations passées en paramètre.
   #
   # == Parameters:
   # intitule : une chaine de caractères correspondant au nom courrament donné au type de nourriture à créer
   # energieRendue : l'énergie que regagnera le personnage en consommant le mangeale
   # prix : le prix à l'achat ou à la revente du mangeable
   #
   def initialize(intitule, energieRendue, prix)
      @intitule      = intitule
      @energieRendue = energieRendue
      @prix          = prix
   end
   
   
   def TypeMangeable.creer(intitule, energieRendue, prix)
      return new(intitule, energieRendue, prix)
   end
   

   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeMangeable sur lequel la méthode est appellée.
   #
   def to_s
      return "[Mangeable de type #{@intitule} | Energie délivrée #{@energieRendue} | Prix #{@prix}]"
   end

end

#Test de la classe :
=begin
nouveauTypeMangeable = TypeMangeable.new("Cuisse de poulet",42,3.50)
BibliothequeTypeMangeable.ajouter("Cuisse de poulet",nouveauTypeMangeable)
puts nouveauTypeMangeable
puts "On vient de créer le type de mangeable #{nouveauTypeMangeable.intitule}."
puts "Il permet de regagner #{nouveauTypeMangeable.energieRendue} d'énergie."
puts "Son prix est de #{nouveauTypeMangeable.prix}."
=end
