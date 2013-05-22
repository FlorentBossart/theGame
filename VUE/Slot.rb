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
# == Un temps de jeu
# == Le mod�le pour stocker l'�tat de la partie en cours et pouvoir charger la partie au m�me �tat
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
   # Construit un nouveau slot de sauvegarde � partir des informations passées en paramètre.
   #
   def initialize(intitule, pseudo, intituleDifficulte, date, temps, modele)
      @intitule	= intitule
      @pseudo		= pseudo
	   @intituleDifficulte = intituleDifficulte
	   @date			= date
	   @temps		= temps
	   @modele		= modele
   end
    
   # Appel de la méthode initialize.
	# == Parameters: 
	#* <b>intitule :</b> une chaine de caract�res correspondant au nom du fichier de sauvegarde (X.yaml)
	#* <b>pseudo :</b> une chaine de caract�res correspondant au nom du joueur
	#* <b>intituleDifficulte :</b> une chaine de caract�res correspondant au nom de de la difficult�
	#* <b>date :</b> une Date correspondant � la date de sauvegarde
	#* <b>temps :</b> un entier correspondant au temps de jeu total du joueur en secondes
	#* <b>modele :</b> le modele de la partie qu'il faut sauvegarder
    def Slot.creer(intitule, pseudo, intituleDifficulte, date, temps, modele)
        return new(intitule, pseudo, intituleDifficulte, date, temps, modele)
    end
               

   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Slot sur lequel la méthode est appellée.
   #
   def to_s
      return "[Intitule #{@intitule} | Pseudo joueur #{@pseudo} | Difficulte #{@intituleDifficulte}" +
      		" | Date #{@date} | Temps #{@temps} | Modele #{@modele}]"
   end

end
