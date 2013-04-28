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
   def initialize(intitule, endroisDePort, pourcentageProtection, nbTours, prix)
      @intitule              = intitule
      @sePorteSur            = endroisDePort
      @pourcentageProtection = pourcentageProtection
      @nbTours               = nbTours
      @prix                  = prix
   end
   
   
   def TypeEquipable.creer(intitule, endroisDePort, pourcentageProtection, nbTours, prix)
      return new(intitule, endroisDePort, pourcentageProtection, nbTours, prix)
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeEquipable sur lequel la méthode est appellée.
   #
   def to_s
      return "[Equipement de type #{@intitule} | Se porte sur #{@sePorteSur} | Pourcentage de protection #{@pourcentageProtection} | Valable pour #{@nbTours} tours | Prix #{@prix}]"
   end

end


#Test de la classe :
=begin
nouveauTypeEquipable = TypeEquipable.new("Soulier","pieds",10,1,2.50)
BibliothequeTypeEquipable.ajouter("Soulier",nouveauTypeEquipable)
puts nouveauTypeEquipable
puts "On vient de créer le type d'équipable #{nouveauTypeEquipable.intitule}."
puts "Qui se porte sur #{nouveauTypeEquipable.sePorteSur}."
puts "Il offre une protection de #{nouveauTypeEquipable.pourcentageProtection}%."
puts "Et ce pendant #{nouveauTypeEquipable.nbTours} tours."
puts "Son prix est de #{nouveauTypeEquipable.prix}."
=end
