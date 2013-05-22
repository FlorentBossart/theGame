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
   @modele


   attr_reader :intitule, :pseudo, :intituleDifficulte, :date, :temps, :modele


   ##
   # Construit un nouveau slot de sauvegarde ‡ partir des informations pass√©es en param√®tre.
   #
   def initialize(intitule, pseudo, intituleDifficulte, date, temps, modele)
      @intitule	= intitule
      @pseudo		= pseudo
	   @intituleDifficulte = intituleDifficulte
	   @date			= date
	   @temps		= temps
	   @modele		= modele
   end
    
   # Appel de la m√©thode initialize.
	# == Parameters: 
	#* <b>intitule :</b> une chaine de caractËres correspondant au nom du fichier de sauvegarde (X.yaml)
	#* <b>pseudo :</b> une chaine de caractËres correspondant au nom du joueur
	#* <b>intituleDifficulte :</b> une chaine de caractËres correspondant au nom de de la difficultÈ
	#* <b>date :</b> une Date correspondant ‡ la date de sauvegarde
	#* <b>temps :</b> un entier correspondant au temps de jeu total du joueur en secondes
	#* <b>modele :</b> le modele de la partie qu'il faut sauvegarder
    def Slot.creer(intitule, pseudo, intituleDifficulte, date, temps, modele)
        return new(intitule, pseudo, intituleDifficulte, date, temps, modele)
    end
               

   ##
   # Retourne une cha√Æne de caract√®res reprenant les diff√©rentes caract√©ristiques
   # de l'objet Slot sur lequel la m√©thode est appell√©e.
   #
   def to_s
      return "[Intitule #{@intitule} | Pseudo joueur #{@pseudo} | Difficulte #{@intituleDifficulte}" +
      		" | Date #{@date} | Temps #{@temps} | Modele #{@modele}]"
   end

end
