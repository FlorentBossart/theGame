#!/usr/bin/env ruby 

## 
# Fichier        : YamlSlot.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier Yaml d'un slot de sauvegarde. Elle permet de lire les infos du fichier yaml
# mais �galement d'�crire dedans pour sauvegarder les informations d'une partie.
#

# Pour enregistrer la date du jour dans les informations de sauvegarde
require 'date'

require 'BibliothequeSlot.rb'
require 'Slot.rb'

require 'yaml.rb'

class YamlSlot
   
   
   # M�thode statique permettant de r�cup�rer les informations d'un slot de sauvegarde
   # et de les ajouter � la liste des infos d'un slot de sauvegarde (classe Sauvegarde).
   #
   def YamlSlot.lireYaml(nomFicSlotYaml)
      #Ouvre le fichier YAML contenant les infos du slot "nomFicXml"
      begin
         file = File.open(nomFicSlotYaml)
      rescue
         raise "Impossible d'ouvrir le fichier " + nomFicSlotYaml
      end

		tabElement = Array.new
		
		# r�cup�re chaque objet contenu dans le doc YAML et les stockent dans un tableau
		YAML.load_documents(file) do |obj| 
			tabElement.push(obj)
		end
		
		# Ajoute le pseudo du joueur, la difficult� et la date aux informations du slot
      BibliothequeSlot.ajouter(nomFicSlotYaml, 
      							Slot.creer(nomFicSlotYaml, tabElement[0], tabElement[1], tabElement[2], tabElement[3]))
 
   end
   

	##
   # M�thode statique permettant d'ajouter les infos pour la sauvegarde d'un joueur au fichier YAML (slotX.yaml)
   #
   # Il faut stocker (dans le fichier yaml) tous les objets n�cessaires au chargement d'une partie :
   # carte (position ennemis, joueur, terrains...) => contenus dans modele
	def YamlSlot.ecrireYaml(nomFicSlotYaml, modele)
    
      begin
	      file = File.open(nomFicSlotYaml, "w")
	      file.syswrite("testNom".to_yaml()) #modele.joueur.pseudo
	      file.syswrite("Expert".to_yaml()) #modele.difficulte.intitule # g�rer par la classe Joueur 
      							# /!\ Avoir un reader sur le modele dans joueur 
      							# ou passer en parametre de la m�thode la difficult� ou le modele)
	      d = Date.today
	      date = d.mday.to_s + "/" + d.mon.to_s + "/" + d.year.to_s
	      file.syswrite(date.to_yaml())
	      file.syswrite(modele.to_yaml())
	   rescue
			raise "Impossible d'ouvrir le fichier " + nomFicSlotYaml + ".yaml"
		ensure
			file.close
		end
		
	end

end


#Test
#YamlSlot.ecrireYaml("test1", nil)

