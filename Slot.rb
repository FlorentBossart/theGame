#!/usr/bin/env ruby

##
# Fichier        : Slot.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de repr√©senter un slot de sauvegarde. Un slot de sauvegarde comprend :
# == Le pseudo du joueur
# == Une difficultÈ
# == Une date
# == Un temps de jeu
# == Le modËle pour stocker l'Ètat de la partie en cours et pouvoir charger la partie au mÍme Ètat
#

require 'date'

class Slot
    
   private_class_method :new
    
    
   @intitule
   @pseudo
   @intituleDifficulte
   @date
   @temps


   attr_reader :intitule, :pseudo, :intituleDifficulte, :date, :temps


   ##
   # Construit un nouveau slot de sauvegarde ‡ partir des informations pass√©es en param√®tre.
   #
   def initialize(intitule, pseudo, intituleDifficulte, date, temps)
      @intitule	= intitule
      @pseudo		= pseudo
	   @intituleDifficulte = intituleDifficulte
	   @date			= date
	   @temps		= temps
   end
    
    # Appel de la m√©thode initialize.
    def Slot.creer(intitule, pseudo, intituleDifficulte, date, temps)
        return new(intitule, pseudo, intituleDifficulte, date, temps)
    end
               

   ##
   # Retourne une cha√Æne de caract√®res reprenant les diff√©rentes caract√©ristiques
   # de l'objet Slot sur lequel la m√©thode est appell√©e.
   #
   def to_s
      return "[Intitule #{@intitule} | Pseudo joueur #{@pseudo} | Difficulte #{@intituleDifficulte} | Date #{@date} | Temps #{@Temps}]"
   end

end


#Test de la classe
=begin
nouvelleSlot = Slot.creer("slot1","Ludovic","Expert",Date.today,nil)
puts nouvelleSlot
=end