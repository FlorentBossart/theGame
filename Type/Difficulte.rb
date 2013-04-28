#!/usr/bin/env ruby

##
# Fichier        : Difficulte.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe permet de représenter une Difficulte de jeu. La difficulté de jeu comprend :
# == Une longueur de carte (en nombre de cases)
# == Une largeur  de carte (en nombre de cases)
# == Une énergie de départ pour le joueur
# == Une énergie maximale pour le joueur
# == Un nombre de repos initial pour le joueur
# == Une quantité de PNJ amis de départ
# == Une quantité de PNJ amis pour génération (nombre d'amis supplémentaires par génération)
# == Une quantité de PNJ ennemis de départ
# == Une quantité de PNJ ennemis pour génération (nombre d'ennemis supplémentaires par génération)
# == Une quantité d'objets de départ
# == Une quantité d'objets pour génération (nombre d'objets supplémentaires par génération)
# == Un nombre de tours pour génération (nombre de tours entre chaque nouvelle génération de PNJ et d'objets)
# == Un pourcentage de coût de terrain (pourcentage de l'énergie des terrain qui sera effectivement consommée lorsque le joueur marchera dessus)
#

class Difficulte
    
   private_class_method :new
    
    
   @intitule
   @longueurCarte
   @largeurCarte
   @energieDepart
   @energieMax
   @nbRepos
   @pnjAmisDepart
   @pnjAmisParGeneration
   @pnjEnnemisDepart
   @pnjEnnemisParGeneration
   @objetsDepart
   @objetsParGeneration
   @nbToursInterGenerations
   @pourcentageTerrain


   attr_reader :intitule, :longueurCarte, :largeurCarte, :energieDepart, :energieMax, :nbRepos, :pnjAmisDepart, :pnjAmisParGeneration, 
               :pnjEnnemisDepart, :pnjEnnemisParGeneration, :objetsDepart, :objetsParGeneration, :nbToursInterGenerations, :pourcentageTerrain


   ##
   # Construit une nouvelle Difficulté à partir des informations passées en paramètre.
   #
   def initialize(intitule, longueurCarte, largeurCarte, energieDepart, energieMax, nbRepos, pnjAmisDepart, pnjAmisParGeneration, pnjEnnemisDepart, pnjEnnemisParGeneration, objetsDepart, objetsParGeneration, nbToursInterGenerations, pourcentageTerrain)
      @intitule=intitule
      @longueurCarte = longueurCarte
      @largeurCarte = largeurCarte
      @energieDepart = energieDepart
      @energieMax = energieMax
      @nbRepos = nbRepos
      @pnjAmisDepart = pnjAmisDepart
      @pnjAmisParGeneration = pnjAmisParGeneration
      @pnjEnnemisDepart = pnjEnnemisDepart
      @pnjEnnemisParGeneration = pnjEnnemisParGeneration
      @objetsDepart = objetsDepart
      @objetsParGeneration = objetsParGeneration
      @nbToursInterGenerations = nbToursInterGenerations
      @pourcentageTerrain = pourcentageTerrain
   end
    
    # Appel de la méthode initialize.
    def Difficulte.creer(intitule, longueurCarte, largeurCarte, energieDepart, energieMax, nbRepos, pnjAmisDepart, pnjAmisParGeneration, pnjEnnemisDepart, pnjEnnemisParGeneration, objetsDepart, objetsParGeneration, nbToursInterGenerations, pourcentageTerrain)
        return new(intitule, longueurCarte, largeurCarte, energieDepart, energieMax, nbRepos, pnjAmisDepart, pnjAmisParGeneration, pnjEnnemisDepart, pnjEnnemisParGeneration, objetsDepart, objetsParGeneration, nbToursInterGenerations, pourcentageTerrain)
    end
               

   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Difficulte sur lequel la méthode est appellée.
   #
   def to_s
      return "[Intitule #{@intitule} | Longueur carte #{@longueurCarte} | Longueur carte #{@largeurCarte} | Energie dep. #{@energieDepart} | Energie max. #{@energieMax} | Nb repos #{@nbRepos} | Nb PNJ amis #{@pnjAmisDepart} , +#{@pnjAmisParGeneration}/généraion | Nb PNJ ennemis #{@pnjEnnemisDepart} , +#{@pnjEnnemisParGeneration}/généraion | Nb objets #{@objetsDepart} , +#{@objetsParGeneration}/généraion | Nb tours entre générations  #{@nbToursInterGenerations} | Pourcentage conso. terrain #{@pourcentageTerrain}]"
   end

end


#Test de la classe
=begin
nouvelleDifficulte = Difficulte.creer("facile",100,100,250,500,3,45,3,25,5,30,2,15,100)
puts nouvelleDifficulte
=end
