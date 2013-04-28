#!/usr/bin/env ruby

##
# Fichier        : TypeTerrain.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un type de terrain. Un type de terrain de défini par :
# == Un intitulé unique permettant de le distinguer
# == Un booléen indiquant si le terrain est accessible ou non (ie si le joueur peut le traverser)
# == Un cout de déplacement (énergie pompée au joueur lorsqu'il franchit le terrain)
#
# Note : On pourrait mettre -1 en cout de déplacement pour stipuler qu'un terrain n'est pas franchissable
require 'BibliothequeTypeTerrain.rb'
class TypeTerrain

   @intitule
   @isAccessible
   @coutDeplacement
   @probaRepartition

    attr_reader :intitule, :isAccessible, :coutDeplacement, :probaRepartition

   ##
   # Crée un nouveau TypeTerrain à partir des informations passées en paramètre.
   #
   # == Parameters:
   # intitule : une chaine de caractères correspondant au nom courrament donné au type de terrain à créer
   # isAccessible : un booléen indiquant si le terrain peut être franchit ou non
   # cout : le cout en énergie que devra consommer le joueur pour franchir le terrain
   #
   def initialize(intitule, isAccessible, cout, proba)
      @intitule        = intitule
      @isAccessible    = isAccessible
      @coutDeplacement = cout
      @probaRepartition= proba
   end


   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeTerrain sur lequel la méthode est appellée.
   #
   def to_s
      s= "[Terrain de type #{@intitule} | "
      if(@isAccessible)
         s+= "Accessible | "
      else
         s+= "Non Accessible | "
      end
      s+= "Cout de déplacement #{@coutDeplacement}]"
      return @intitule.chars.to_a[0]
   end

end


#Test de la classe :
nouveauTypeTerrain = TypeTerrain.new("Eau",false,-1,65)
BibliothequeTypeTerrain.ajouter("Eau",nouveauTypeTerrain)
nouveauTypeTerrain = TypeTerrain.new("Sable",true,4,80)
BibliothequeTypeTerrain.ajouter("Sable",nouveauTypeTerrain)
nouveauTypeTerrain = TypeTerrain.new("Rocher",true,5,80)
BibliothequeTypeTerrain.ajouter("Rocher",nouveauTypeTerrain)
nouveauTypeTerrain = TypeTerrain.new("Plaine",true,2,50)
BibliothequeTypeTerrain.ajouter("Plaine",nouveauTypeTerrain)

