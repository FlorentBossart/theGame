#!/usr/bin/env ruby 

## 
# Fichier        : ReferencesGraphiques.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de créer une "bibliothèque" de références graphiques. 
# Elle permet d'associer une image avec un intitulé unique d'un élément aggichable à la manière d'une HashMap
#

class ReferencesGraphiques

   @biblioGraphique

   ##
   # Constucteur : permet d'initialiser un Hash qui contiendra pour chaque intitulé unique d'élément affichable
   # la référence vers le fichier image qui le représente.
   #
   def initialize
      @biblioGraphique = Hash.new
   end


   ##
   # Permet d'ajouter une référence graphique à la bibliothèque
   # == Parameters: 
   #* <b>intitule :</b> une chaine de caractères correspondant au nom courrament donné à l'objet affichable
   #* <b>cheminImg :</b> le chemin vers le fichier image représentant l'objet affichable dans l'IHM
   # 
   def addRefGraphique(intitule, cheminImg)
	@biblioGraphique[intitule] = cheminImg
   end


   ##
   # Permet d'ajouter une référence graphique à la bibliothèque
   # == Parameters: 
   #* <b>intitule :</b> une chaine de caractères correspondant au nom courrament donné à l'objet affichable
   # == Returns: 
   #* <b>fichierImg :</b> le chemin vers le fichier image représentant l'objet affichable dans l'IHM
   # 
   def getRefGraphique(intitule)
      return @biblioGraphique[intitule]
   end 


   ##
   # Permet de renvoyer une chaîne de caractères représentant la bibliothèque d'éléments graphiques
   # sous la forme d'une liste de lignes <intitutle> à pour image <fichier_image>
   # == Returns: 
   #* <b>s :</b> ne chaîne de caractères représentant la bibliothèque d'éléments graphiques
   # 
   def to_s
      s = ""
      @biblioGraphique.each {|key, value| s += "#{key} à pour image #{value}\n" }
      return s
   end

end

