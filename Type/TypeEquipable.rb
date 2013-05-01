#!/usr/bin/env ruby

##
# Fichier        : TypeEquipable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un type d'objet dont on peux s'équiper. Un objet équipable se défini par :
# == Un intitulé unique permettant de le distinguer
# == Une valeur représentant le pourcentage de protection apporté par le port de l'équipement
# == Une valeur représentant le nombre de tour où l'on conservera l'équipement
# == Un cout d'achat/revente (prix)
#



class TypeEquipable

   @intitule
   @pourcentageProtection
   @nbTours
   @prix
   @sePorteSur

   attr_reader :intitule, :sePorteSur, :pourcentageProtection, :nbTours, :prix

   ##
   # Crée un nouveau TypeEquipable à partir des informations passées en paramètre.
   #
   # == Parameters:
   # intitule : une chaine de caractères correspondant au nom courrament donné au type de nourriture à créer
   # pourcentageProtection : le proucentage de protection apporté par le port de l'équipement
   # nbTours : le nombre de tours durant lequel le personnage conservera l'équipement avant qu'il ne disparaisse
   # prix : le prix à l'achat ou à la revente de l'équipement
   #
   def initialize(intitule, pourcentageProtection, nbTours, prix, endroisDePort)
      @intitule              = intitule
      @sePorteSur            = endroisDePort
      @pourcentageProtection = pourcentageProtection
      @nbTours               = nbTours
      @prix                  = prix
   end
   
   
   def TypeEquipable.creer(intitule, pourcentageProtection, nbTours, prix, endroisDePort)
      return new(intitule, pourcentageProtection, nbTours, prix, endroisDePort)
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeEquipable sur lequel la méthode est appellée.
   #
   def to_s
     s= "[==TypeEquipable >>> | "
     s+= "Intitulé: #{@intitule} | "
     s+= "Se porte sur: #{@sePorteSur} | "
     s+= "Pourcentage de protection: #{@pourcentageProtection*100}% | "
     s+= "Valable pour #{@nbTours} tours | "
     s+= "Prix: #{@prix} | "
     s+= "<<< TypeEquipable==]"
     return s
   end

end

