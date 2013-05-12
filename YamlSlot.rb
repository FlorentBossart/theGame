#!/usr/bin/env ruby 

## 
# Fichier        : YamlSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier Yaml d'un slot de sauvegarde. Elle permet de lire les infos du fichier yaml
# mais également d'écrire dedans pour sauvegarder les informations d'une partie.
#

# Pour enregistrer la date du jour dans les informations de sauvegarde
require 'date'

require './Bibliotheque/BibliothequeSlot.rb'
require 'Slot.rb'

require 'yaml.rb'

class YamlSlot
   
   
   # Méthode statique permettant de récupérer les informations d'un slot de sauvegarde
   # et de les ajouter à la liste des infos d'un slot de sauvegarde (classe Slot).
   #
   def YamlSlot.lireYaml(nomFicSlotYaml, joueur)
      #Ouvre le fichier YAML contenant les infos du slot "nomFicXml"
      begin
         file = File.open("YAMLSlot/" + nomFicSlotYaml)
      rescue
         raise "Impossible d'ouvrir le fichier YAMLSlot/" + nomFicSlotYaml
      end

		tabElement = Array.new
		
		# récupère chaque objet contenu dans le doc YAML et les stockent dans un tableau
		YAML.load_documents(file) do |obj| 
			tabElement.push(obj)
		end
		
		pseudo 	= tabElement[0]
		nomDiff 	= tabElement[1]
		date 		= tabElement[2]
		temps 	= tabElement[3]
		
		
		# Ajoute le pseudo du joueur, la difficulté et la date aux informations du slot
      BibliothequeSlot.ajouter(nomFicSlotYaml, 
      							Slot.creer(nomFicSlotYaml, pseudo, nomDiff, date, temps))
 
   end
   

	##
   # Méthode statique permettant d'ajouter les infos pour la sauvegarde d'un joueur au fichier YAML (slotX.yaml)
   #
   # Il faut stocker (dans le fichier yaml) tous les objets nécessaires au chargement d'une partie :
   # carte (position ennemis, joueur, terrains...) => contenus dans modele
	def YamlSlot.ecrireYaml(nomFicSlotYaml, modele)
    
      begin
	      file = File.open("YAMLSlot/" + nomFicSlotYaml, "w")
	      #file.syswrite("testNom".to_yaml()) #modele.joueur.pseudo
	      #file.syswrite("Expert".to_yaml()) #modele.difficulte.intitule # gérer par la classe Joueur 
      							# /!\ Avoir un reader sur le modele dans joueur 
      							# ou passer en parametre de la méthode la difficulté ou le modele)
      	puts "pseudo : "
      	p modele.joueur.pseudo
      	file.syswrite(modele.joueur.pseudo.to_yaml())
      	
      	puts "diff : " + modele.difficulte.intitule
      	file.syswrite(modele.difficulte.intitule.to_yaml())
      	
	      d = Date.today
	      date = d.mday.to_s + "/" + d.mon.to_s + "/" + d.year.to_s
	      puts "date : " + date
	      file.syswrite(date.to_yaml())
	      
	      puts "temps jeu : " + modele.joueur.tempsTotal.to_s
	      file.syswrite(modele.joueur.tempsTotal.to_yaml())
	      
	      #puts modele.joueur
	     # file.syswrite(modele.joueur.to_yaml())
	      puts modele
	      file.syswrite(modele.to_yaml())
	      #puts "carte : "
	      #p modele.carte
	      #file.syswrite(modele.carte.to_yaml())
	    #  file.syswrite(modele.to_yaml()) # Marche pas pour l'instant, car peut etre que tous les champs ne sont pas bien remplis encore
	   rescue
			raise "Impossible d'ouvrir le fichier YAMLSlot/" + nomFicSlotYaml
		ensure
			file.close
		end
		
	end

end


#Test
#YamlSlot.ecrireYaml("test1", nil)


