#!/usr/bin/env ruby

##
# Fichier        : Encaissable.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la caractéristique encaissable définie par :
# == Un montant
#

require 'MODELE/Caracteristique.rb'
require 'MODELE/Joueur.rb'

class Encaissable < Caracteristique

   @montant
   @intitule

   attr_reader :montant
   
   
   def initialize(montant)
      super()
      @montant=montant
      @intitule="Bourse"
   end

   
   ##
   # Crée un nouveau Encaissable à partir des informations passées en paramètre.
   #
   # == Parameters:
   # montant : la valeur monaitaire de la bourse
   #
   def Encaissable.creer(montant)
      new(montant)
   end

   
   def getIntitule()
      return @intitule
   end

  def estStockable?()
    return false
  end
   
   def utiliseToi(joueur)
      joueur.inventaire.capital=joueur.inventaire.capital+@montant
      str=XmlMultilingueReader.lireTexte("encaissement")
      str=str.gsub("MONTANT",@montant.to_s())
      joueur.modele.notifier(str)
      return nil
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Encaissable sur lequel la méthode est appellée.
   #
   def to_s
      #s= "[==Encaissable >>> | "
      #s+= "Intitulé: #{@intitule} | "
      #s+= "Montant: #{@montant} | "
      #s+= "<<< Encaissable==]"
     s=XmlMultilingueReader.lireTexte("to_sEncaissable")
     s=s.gsub("INTITULE",@intitule).gsub("OR",@montant.to_s)
      return s
   end

end