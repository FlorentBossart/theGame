#!/usr/bin/env ruby

##
# Fichier        : Equipable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la caractéristique équipable définie par :
# == Un type d'objet équipable
# == un nombre d'utilisations réstantes
#

require './Caracteristique.rb'
require './Type/TypeEquipable.rb'
require './Joueur.rb'

class Equipable < Caracteristique

   @typeEquipable
   @nbUtilisationsRestantes

   
   attr_reader :typeEquipable
   attr_accessor :nbUtilisationsRestantes
   
   def initialize(typeEquipable)
      @typeEquipable = typeEquipable
      @nbUtilisationsRestantes = typeEquipable.nbTours
   end

   
   ##
   # Crée un nouveau Equipable à partir des informations passées en paramètre.
   #
   # == Parameters:
   # montant : la valeur monaitaire de la bourse
   #
   def Equipable.creer(typeEquipable)
      new(typeEquipable)
   end

   def getIntitule()
      return @typeEquipable.intitule
   end

   
   def utiliseToi(joueur)
      if(@typeEquipable.sePorteSur == "armure")
         joueur.armure=self
      elsif(@typeEquipable.sePorteSur == "arme")
         joueur.arme=self
      elsif(@typeEquipable.sePorteSur == "bottes")
         joueur.bottes=self
      end
      joueur.modele.notifier("Vous vous êtes équipé de #{getIntitule()}")
   end

   
   def estEquipable?()
      return true
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Equipable sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==Equipable >>> | "
      s+= "Type #{@typeEquipable}  | "
      s+= "Reste #{@nbUtilisationsRestantes} utilisation  | "
      s+= "<<< Equipable==]"
      return s
   end

end