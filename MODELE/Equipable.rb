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

require 'MODELE/Caracteristique.rb'
require 'MODELE/Type/TypeEquipable.rb'
require 'MODELE/Joueur.rb'
require 'MODELE/Enum/EnumEmplacementEquipement.rb'

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

  def estEquipable?()
        return true
      end
   
   def getIntitule()
      return @typeEquipable.intitule
   end

   def prix
     return @typeEquipable.prix
   end
   
   def utiliseToi(joueur)
      if(@typeEquipable.sePorteSur == EnumEmplacementEquipement.ARMURE)
         joueur.armure=self
      elsif(@typeEquipable.sePorteSur == EnumEmplacementEquipement.ARME)
         joueur.arme=self
      elsif(@typeEquipable.sePorteSur == EnumEmplacementEquipement.BOTTES)
         joueur.bottes=self
      end
     str=XmlMultilingueReader.lireTexte("equipement")
     str=str.gsub("EQUIPEMENT",XmlMultilingueReader.lireDeterminant_Nom(self))
     joueur.modele.notifier(str)
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Equipable sur lequel la méthode est appellée.
   #
   def to_s
     s=XmlMultilingueReader.lireTexte("to_sEquipable")
     s=s.gsub("TYPEEQUIP",@typeEquipable.description).gsub("NBUTIL",@nbUtilisationsRestantes.to_s)
      #s= "[==Equipable >>> | "
      #s+= "Type #{@typeEquipable}  | "
      #s+= "Reste #{@nbUtilisationsRestantes} utilisation  | "
      #s+= "<<< Equipable==]"
      return s
   end

end