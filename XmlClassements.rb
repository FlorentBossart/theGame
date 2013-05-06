#!/usr/bin/env ruby 

## 
# Fichier        : XmlClassements.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier XML des statistiques de chaque joueur 
# et de les ajouter à la liste des joueurs classé (classe Classements).
#

require'Classements.rb'

require 'rexml/document'
include REXML

class XmlClassements


   ##
   # Méthode statique permettant de récupérer les statistiques des différents joueurs
   # et de les ajouter à la liste des joueurs classé (classe Classements).
   #
   def XmlClassements.lireXml(listeStatsJoueurs)
      #Ouvre le fichier XML contenant les statistiques de chaque joueur
      begin
         file = File.new("classements.xml")
         doc = Document.new(file)
      rescue
         raise "Impossible d'ouvrir le fichier XML des classements des joueurs."
      end

      #Pour chaque joueur du fichier XML...
      doc.elements.each('classements_joueur/joueur') do |j|
         #... on ajoute les stats à la liste des stats de chaque joueur
         listeStatsJoueurs.addJoueur(j.elements['nom'].text, j.elements['nb_ennemis_tues'].text.to_i, j.elements['distance'].text.to_i, 
         								j.elements['or'].text.to_i, j.elements['temps'].text.to_i, j.elements['difficulte'].text)
      end

   end
   
   
   ##
   # Méthode statique permettant d'ajouter les statistiques d'un joueur au fichier XML (classements.xml)
   #
   def XmlClassements.ecrireXml(modele) # Prendre un Modele en paramètre ?
   	   	
      if(File.exist?("classements.xml") == false)# Création du fichier s'il n'existe pas
      	begin
	         file = File.open("classements.xml", "w")
	         file.syswrite("<?xml version = \"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n\n")
		      file.syswrite("<!DOCTYPE classements_joueur [\n" +
									"<!ELEMENT classements_joueur (joueur+)>\n" +
									"<!ELEMENT joueur (nom, nb_ennemis_tues, distance, or, temps, difficulte)>\n" +
									"<!ELEMENT nom (#PCDATA)>\n" +
									"<!ELEMENT nb_ennemis_tues (#PCDATA)>\n" +
									"<!ELEMENT distance (#PCDATA)>\n" +
									"<!ELEMENT or (#PCDATA)>\n" +
									"<!ELEMENT temps (#PCDATA)>\n" +
									"<!ELEMENT difficulte (#PCDATA)>\n" +
									"]>\n\n")
				doc = Document.new()
				doc.add_element("classements_joueur")
		      file.write(doc)
		      file.close
		   rescue
		   	raise "Impossible d'ouvrir le fichier classements.xml"
		   end
      end
      
      doc = Document.new(File.open("classements.xml"))
      
      joueur = Element.new("joueur")
      
      nom = Element.new("nom")
      nom.text = "BestOfTheBest" # modele.joueur.pseudo # gérer par la classe Joueur 
      joueur.add_element(nom)
      
      nbEnnemisTues = Element.new("nb_ennemis_tues")
      nbEnnemisTues.text = 32 # modele.joueur.nbEnnemiTues # gérer par la classe Joueur
      joueur.add_element(nbEnnemisTues)
      
      dist = Element.new("distance")
      dist.text = 3200 # modele.joueur.distanceParcourue # gérer par la classe Joueur
      joueur.add_element(dist)
      
      argent = Element.new("or")
      argent.text = 33333 # modele.joueur.inventaire.capital # gérer par la classe Inventaire
      joueur.add_element(argent)
      
      tps = Element.new("temps")
      tps.text = 9999 # ??? joueur.temps # gérer par la classe Modele
      joueur.add_element(tps)
      
      diff = Element.new("difficulte")
      diff.text = "Expert" # modele.difficulte.intitule # gérer par la classe Modele
      joueur.add_element(diff)
      
      doc.root.add_element(joueur)
      
      # MAJ du fichier xml du classement des joueurs
		begin
	      # w : Write-only, truncates existing file to zero length or creates a new file for writing.
	      file = File.open("classements.xml", "w")
	      file.write(doc)
		rescue
			raise "Impossible d'ouvrir le fichier classements.xml"
		ensure
			file.close
		end

	end
	
end


