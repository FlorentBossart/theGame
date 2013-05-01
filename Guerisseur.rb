#!/usr/bin/env ruby

##
# Fichier         : Guerisseur.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe représente un personnage non joueur Ami Guerisseur. 
#  Un personnage non joueur Ami Guerisseur est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Une image le représentant
#

require './Ami.rb'

class Guerisseur < Ami
  
   
   # Initialise l'instance de la classe Guerisseur
   # avec le parametre Case _casePosition_.
   ##
   # Crée un nouvel Ami Guerisseur à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami guerisseur
   #
   def initialize(casePosition)
      super(casePosition)
      @intitule = "Guerisseur"
   end
  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami guerisseur
   #
   def Guerisseur.creer(casePosition)
      return new(casePosition)
   end
  

   ##
   # Permet au Guerisseur du guerrir un joueur.
   #
   # == Parameters:
   #* <b>joueur :</b> le joueur que l'on veut guerir
   #* <b>choix :</b> le numero du choix choisit
   #
   def guerrir(joueur, choix)
      case choix
         when 0
            energieG = joueur.energie + joueur.energieMax * 0.25
            joueur.debourser(30)
            joueur.modele.notifier("Vous avez été guérri de 25% de votre énergie maximale")
         when 1
            energieG = joueur.energie + joueur.energieMax * 0.5
            joueur.debourser(50)
            joueur.modele.notifier("Vous avez été guérri de 50% de votre énergie maximale")
         else
            energieG = joueur.energie + joueur.energieMax * 0.75
            joueur.debourser(70)
        joueur.modele.notifier("Vous avez été guérri de 75% de votre énergie maximale")
      end
    
      if(energieG > joueur.energieMax)
         joueur.energie = joueur.energieMax
      else
         joueur.energie = energieG
      end
    
      return nil
   end
  
  ##
  # Represente l'interaction avec un element present sur une case (dans ce cas interargir avec un commercant)
  #
  def interaction(joueur)
    joueur.modele.pnjAideEnInteraction=self  
    joueur.modele.changerStadePartie(EnumStadePartie.INTERACTION_GUERISSEUR)
  end
   
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Guerisseur sur lequel la méthode est appellée.
   #
   def to_s
     s= "[==Guerisseur >>> | "
     s+= super()
     s+= "<<< Guerisseur==]"
   end

end