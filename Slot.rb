#!/usr/bin/env ruby

##
# Fichier        : Slot.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de représenter un slot de sauvegarde. Un slot de sauvegarde comprend :
# == Le pseudo du joueur
# == Une difficult�
# == Une date
# == Le mod�le pour stocker l'�tat de la partie en cours et pouvoir charger la partie au m�me �tat
#

require 'date'

class Slot
    
   private_class_method :new
    
    
   @intitule
   @pseudo
   @intituleDifficulte
   @date
   @modele


   attr_reader :intitule, :pseudo, :intituleDifficulte, :date, :modele


   ##
   # Construit un nouveau slot de sauvegarde � partir des informations passées en paramètre.
   #
   def initialize(intitule, pseudo, intituleDifficulte, date, modele)
      @intitule	= intitule
      @pseudo		= pseudo
	   @intituleDifficulte = intituleDifficulte
	   @date			= date
	   @modele		= modele
   end
    
    # Appel de la méthode initialize.
    def Slot.creer(intitule, pseudo, intituleDifficulte, date, modele)
        return new(intitule, pseudo, intituleDifficulte, date, modele)
    end
               

   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Slot sur lequel la méthode est appellée.
   #
   def to_s
      return "[Intitule #{@intitule} | Pseudo joueur #{@pseudo} | Difficulte #{@intituleDifficulte} | Date #{@date} | Modele #{@modele}]"
   end

end


#Test de la classe
=begin
nouvelleSlot = Slot.creer("slot1","Ludovic","Expert",Date.today,nil)
puts nouvelleSlot
=end