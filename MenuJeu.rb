#!/usr/bin/env ruby

## 
# Fichier        : MenuJeu.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de crï¿½er le menu du jeu et contient :
#* Une fenï¿½tre reprï¿½sentant la fenetre du menu 
#* Un boolï¿½en indiquant si le joueur est en cours de jeu ou non, ce qui modifiera les boutons du menu en consï¿½quence
#* Un contenu reprï¿½sentï¿½ par une box et qui contient les ï¿½lï¿½ments de chaque "sous-menu" (nouvelle partie, classement, ...)
# 

require 'gtk2'

require 'Classements.rb'
require './XMLReader/XmlClassements.rb'
require './XMLReader/XmlMultilingueReader.rb'

require './Bibliotheque/BibliothequeSlot.rb'
require 'YamlSlot.rb'
require 'Slot.rb'

# On inclu le module Gtk, cela ï¿½vite de prï¿½fixer les classes par Gtk::
include Gtk

class MenuJeu
	
	@fenetreMenu
	@isInGame
	@contenu
	@controleur
	@modele
	
	attr_accessor :fenetreMenu
	
	attr_reader :contenu
	
	private_class_method :new
	
	def initialize(isEnJeu, modele, controleur)
		
		@isInGame 		= isEnJeu
		@controleur 	= controleur
		@modele 			= modele
		@fenetreMenu 	= Window.new()
		@fenetreMenu.set_default_size(300,300)
		
	end
	
	
	##
   # Crï¿½e un nouveau Menu
   #
   # == Parameters:
   # isEnJeu : un boolï¿½en indiquant si le joueur est en jeu ou non
   #
	def MenuJeu.creer(isEnJeu, modele, controleur)
		return new(isEnJeu, modele, controleur)
	end
	
	
	##
   # Vide la fenï¿½tre de tous ses composants.
   #
   # == Parameters:
   # box : une boite ï¿½ supprimer de la fenetre
   #
	def viderFenetre(box)
		@fenetreMenu.remove(box)
	end
	
	
	##
   # Initialise la fenï¿½tre du menu avec les boutons nï¿½cessaires
   #
	def afficherMenu()
	  	@fenetreMenu=Window.new()
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("nomMenu"))
		# L'application est toujours centree
		#@fenetreMenu.set_window_position(Window::POS_CENTER_ALWAYS)
		@fenetreMenu.resize(300,300)
		
		@contenu = VBox.new(false, 0)
		
		# Crï¿½ation des boutons
		if(@isInGame == false)
			boutNewPartie 		= Button.new(XmlMultilingueReader.lireTexte("NewPartie"))
			boutChargerPartie = Button.new(XmlMultilingueReader.lireTexte("ChargerPartie"))
			boutClassement 	= Button.new(XmlMultilingueReader.lireTexte("Classement"))
			boutOptions 		= Button.new(XmlMultilingueReader.lireTexte("Options"))
			boutAide 			= Button.new(XmlMultilingueReader.lireTexte("Aide"))
			boutQuitter 		= Button.new(XmlMultilingueReader.lireTexte("Quitter"))
			
			@contenu.add(boutNewPartie)
			@contenu.add(boutChargerPartie)
			@contenu.add(boutClassement)
			@contenu.add(boutOptions)
			@contenu.add(boutAide)
			@contenu.add(boutQuitter)
		else
			boutContinuerPartie		= Button.new(XmlMultilingueReader.lireTexte("ContinuerPartie"))
			boutNewPartie 				= Button.new(XmlMultilingueReader.lireTexte("NewPartie"))
			boutChargerPartie 		= Button.new(XmlMultilingueReader.lireTexte("ChargerPartie"))
			boutSauvegarderPartie 	= Button.new(XmlMultilingueReader.lireTexte("SauvegarderPartie"))
			boutClassement 			= Button.new(XmlMultilingueReader.lireTexte("Classement"))
			boutOptions 				= Button.new(XmlMultilingueReader.lireTexte("Options"))
			boutAide 					= Button.new(XmlMultilingueReader.lireTexte("Aide"))
			boutQuitter 				= Button.new(XmlMultilingueReader.lireTexte("Quitter"))
				
			@contenu.add(boutContinuerPartie)
			@contenu.add(boutNewPartie)
			@contenu.add(boutChargerPartie)
			@contenu.add(boutSauvegarderPartie)
			@contenu.add(boutClassement)
			@contenu.add(boutOptions)
			@contenu.add(boutAide)
			@contenu.add(boutQuitter)
			
			@controleur.continuerPartieCreer(boutContinuerPartie,@fenetreMenu)
			@controleur.sauvegarderPartieCreer(boutSauvegarderPartie,@fenetreMenu)
		end
		
		@fenetreMenu.add(@contenu)
		
		@fenetreMenu.show_all
		
		@controleur.nouvellePartieCreer(boutNewPartie,@fenetreMenu)
		@controleur.chargerPartieCreer(boutChargerPartie,@fenetreMenu)
		@controleur.classementCreer(boutClassement,@fenetreMenu)
		@controleur.optionsCreer(boutOptions,@fenetreMenu)
		@controleur.aideCreer(boutAide,@fenetreMenu)
		@controleur.quitterPartieCreer(boutQuitter,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
		
	end
	
	
	##
   # Lorsque le joueur clique sur nouvelle partie, affiche un champ pour le nom du joueur, 
   # des boutons radio pour le choix de difficultï¿½ et un bouton lancer partie
   #
	def afficherNouvellePartie()
		# Remarque : c'est le controleur qui rï¿½cupï¿½re les donnï¿½es (nom, difficultï¿½)
		
		####### Pour tester #######
=begin		@modele.joueur.dateFinJeu = Time.now
		puts "date fin : " + @modele.joueur.dateFinJeu.to_s
		puts "diff a ajouter : " + (@modele.joueur.dateFinJeu-@modele.joueur.dateDebutJeu).to_s
		@modele.joueur.calculerTempsTotal
=end
		####### Fin Test ########
		
		@fenetreMenu = Window.new
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("NewPartie"))
		@fenetreMenu.resize(100,100)
		
		@contenu = VBox.new(true, 10)
		
		maHBoxNom 	= HBox.new(true, 10) # 10 => espace entre 2 "objets"
		labelNom 	= Label.new(XmlMultilingueReader.lireTexte("votreNom"))
		champNom 	= Entry.new()
		
		maHBoxNom.add(labelNom)
		maHBoxNom.add(champNom)
		
		maHboxDifficulte 	= HBox.new(true, 10)
		labelDiff 			= Label.new(XmlMultilingueReader.lireTexte("difficulte"))
		novice 				= RadioButton.new(XmlMultilingueReader.lireTexte("novice"))
		moyen 				= RadioButton.new(novice, XmlMultilingueReader.lireTexte("moyen"))
		expert 				= RadioButton.new(novice, XmlMultilingueReader.lireTexte("expert"))
		
		maHboxDifficulte.add(labelDiff)
		maHboxDifficulte.add(novice)
		maHboxDifficulte.add(moyen)
		maHboxDifficulte.add(expert)
		
		maHBoxBouton 				= HBox.new(true, 10)
		boutCommencerNewPartie 	= Button.new(XmlMultilingueReader.lireTexte("cestPartie"))
		boutRetour 					= Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		maHBoxBouton.add(boutCommencerNewPartie)
		maHBoxBouton.add(boutRetour)
		
		@contenu.add(maHBoxNom)	
		@contenu.add(maHboxDifficulte)		
		@contenu.add(maHBoxBouton)
		@contenu.set_border_width(20)		
		
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all

		@controleur.commencerNewPartieCreer(boutCommencerNewPartie, champNom, novice, moyen, expert, @fenetreMenu)
		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
		
	end
	

	##
   # Lorsque le joueur clique sur charger partie, affiche les slots de chargement d'une partie
   #
	def afficherChargerPartie()
    	@fenetreMenu  = Window.new()
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("ChargerPartie"))
		
		@contenu = VBox.new(false, 20)
		# Tableau contenant des EventBox pouvant ï¿½tre cliquï¿½es pour charger une partie
		tabEventBox = Array.new
		
		# Tableau contenant les slots de sauvegarde
		tabSlot = Array.new
		
		# Remplissage des frames contenant les diffï¿½rentes EventBox
		# Ces EventBox contiennent elles-mï¿½mes des infos (@contenus dans le fichier yaml) sur le slot de sauvegarde en question
		0.upto(4) do |i|
			frame = Frame.new(XmlMultilingueReader.lireTexte("emplacement") + " " + (i+1).to_s)
			nomFicYaml = "slot" + (i+1).to_s + ".yaml"
			
			if(File.exist?("YAMLSlot/" + nomFicYaml)) # Si le fichier yaml correspondant au slot existe
				YamlSlot.lireYaml(nomFicYaml)
				slot = BibliothequeSlot.getSlot(nomFicYaml)
				nom = slot.pseudo
				diff = slot.intituleDifficulte
				date = slot.date
			else # Pour l'affichage des slots vides
				nom = "..."
				diff = "..."
				date = "..."
			end
			
			lab = Label.new(XmlMultilingueReader.lireTexte("nom") + " : " + nom + 
							" | " + XmlMultilingueReader.lireTexte("difficulte") + " : " + diff + 
							" | " + XmlMultilingueReader.lireTexte("date") + " : " + date)
			lab.set_height_request(50)
			frame.add(lab)
			
			eventbox = EventBox.new.add(frame)
			eventbox.events = Gdk::Event::BUTTON_PRESS_MASK
			
			tabSlot[i] = slot
			tabEventBox[i] = eventbox
			
			@contenu.add(eventbox)
		end
		
		boutRetour = Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		@contenu.add(boutRetour)
		@contenu.set_border_width(20)
		
		@fenetreMenu.add(@contenu)
		
		# C'est une fois que les eventBox sont crï¿½es et ajoutï¿½es ï¿½ la fenetre qu'elles sont associï¿½es ï¿½ une Gdk::Window (et non Gtk::Window)
		# On peut donc appeler eventbox.window pour pouvoir modifier la zone correspondante ï¿½ cette eventBox
		tabEventBox.each_with_index{|eb, index|
			eb.realize # Crï¿½er la fenetre GDK (Gdk::Window) associï¿½es au widget
			if(tabSlot[index] != nil)	# Si le slot "existe"
				eb.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
				eb.signal_connect('button_press_event') { 
					puts " Chargement du slot" + (index+1).to_s 
					@modele.joueur.tempsTotal = tabSlot[index].temps # On reprend le temps de la save pour l'ajouter au temps de la session de jeu en cours
					puts "temps de jeu session d'avant : " + @modele.joueur.tempsTotal.to_s
					
					
					#puts "modele charger : " + tabSlot[index].modele.to_s
					#@modele = tabSlot[index].modele
					modeleCharger = tabSlot[index].modele
					
					@fenetreMenu.destroy
					#Destruction ancienne vue partie
					@modele.vue.window.destroy
					puts "Destroy partie"
					
					# Creation de la vue chargée
					vue = modeleCharger.vue
					puts "Vue creer"
					
					
					#controller = Controller.creer(modele,vue)
					controller = modeleCharger.vue.controller
					puts "controller creer"
					
					vue.defM(modeleCharger)
					vue.defC(controller)
					puts "vue defc"
					#modele.initialiseToi()
					#puts "init modele"
					vue.initInterface()
					puts "init interface"
				}
			end
		}
		
		
		
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end
	
	
	##
   # Lorsque le joueur clique sur sauvegarder partie, affiche les slots de sauvegarde d'une partie
   #
	def afficherSauvegarderPartie()		
    	@fenetreMenu  = Window.new()
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("SauvegarderPartie"))
		
		@contenu = VBox.new(false, 20)
		# Tableau contenant des EventBox pouvant ï¿½tre cliquï¿½es pour sauvegarder une partie
		tabEventBox = Array.new
		
		# Tableau contenant les slots de sauvegarde
		tabSlot = Array.new
		
		# Remplissage des frames contenant les diffï¿½rentes EventBox
		# Ces EventBox contiennent elles-mï¿½mes des infos (contenus dans le fichier yaml) sur le slot de sauvegarde en question
		0.upto(4) do |i|
			frame = Frame.new(XmlMultilingueReader.lireTexte("emplacement") + " " + (i+1).to_s)
			nomFicYaml = "slot" + (i+1).to_s + ".yaml"
			
			if(File.exist?("YAMLSlot/" + nomFicYaml)) # Si le fichier yaml correspondant au slot existe
				YamlSlot.lireYaml(nomFicYaml)
				slot = BibliothequeSlot.getSlot(nomFicYaml)
				nom = slot.pseudo
				diff = slot.intituleDifficulte
				date = slot.date
				puts slot.to_s
			else # Pour l'affichage des slots vides
				nom = "..."
				diff = "..."
				date = "..."
			end
			
			lab = Label.new(XmlMultilingueReader.lireTexte("nom") + " : " + nom + 
							" | " + XmlMultilingueReader.lireTexte("difficulte") + " : " + diff + 
							" | " + XmlMultilingueReader.lireTexte("date") + " : " + date)
			lab.set_height_request(50)
			frame.add(lab)
			
			eventbox = EventBox.new.add(frame)
			eventbox.events = Gdk::Event::BUTTON_PRESS_MASK
			
			tabSlot[i] = slot
			tabEventBox[i] = eventbox
			
			@contenu.add(eventbox)
		end
		
		@fenetreMenu.add(@contenu)
				
		# C'est une fois que les eventBox sont crï¿½es et ajoutï¿½es ï¿½ la fenetre qu'elles sont associï¿½es ï¿½ une Gdk::Window (et non Gtk::Window)
		# On peut donc appeler eventbox.window pour pouvoir modifier la zone correspondante ï¿½ cette eventBox
		tabEventBox.each_with_index{|eb, index|
			eb.realize # Crï¿½er la fenetre GDK (Gdk::Window) associï¿½es au widget
			eb.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND2) # Change le curseur en forme de main
			
			eb.signal_connect('button_press_event') { 
				puts "\tSauvegarde sur le slot" + (index+1).to_s 
				YamlSlot.ecrireYaml("slot" + (index+1).to_s + ".yaml", @modele)
				
				@fenetreMenu.destroy()
				# MAJ de l'affichage des slots de sauvegarde
				#viderFenetre(@contenu)
				afficherSauvegarderPartie()
			}
		}
		
		boutRetour = Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		@contenu.add(boutRetour)
		
		@contenu.set_border_width(20)
		
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end
	
	
	##
   # Lorsque le joueur clique sur classement, affiche le classement des meilleurs joueurs
   # en rï¿½cupï¿½rant les donnï¿½es du fichier XML
   #
	def afficherClassement()	
    	@fenetreMenu  = Window.new()
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("Classement"))
		@fenetreMenu.resize(300,390)
		
		@contenu = VBox.new(false, 10)
		
		labelInfo = Label.new(XmlMultilingueReader.lireTexte("infoClassement"))
		labelInfo.justify=Gtk::JUSTIFY_CENTER
  		labelInfo.wrap=true
		
		nb = Notebook.new()
		
		tabLabel = Array.new
		tabLabel[0] = Label.new(XmlMultilingueReader.lireTexte("novice"))
		tabLabel[1] = Label.new(XmlMultilingueReader.lireTexte("moyen"))
		tabLabel[2] = Label.new(XmlMultilingueReader.lireTexte("expert"))
		
		# Rempli toutes les listes de joueurs de toutes les difficultes : retourne un classement
		c = remplirListeJoueur()
		
		#XmlClassements.ecrireXml(@modele) ###### !!!!!! A mettre en fin de partie !!!!!!!! ######
		

		  0.upto(2) do |i|
			# Rempli une liste de joueur suivant leur niveau de difficultï¿½
			#listeJoueur = remplirListeJoueur(tabLabel[i].text)
			
			# Crï¿½ation des treeView
			treeview = TreeView.new
			
			# Ajout des paramï¿½tres de rendu aux treeViews
			setup_tree_view(treeview)
			
			# Crï¿½ation et remplissage des ListStore
			#store = remplirListStore(listeJoueur)
			store = remplirListStore(c.getListeJoueur(tabLabel[i].text))
			
			# Ajoute chacun des tree model au tree view correspondant
			treeview.model = store
			
			# Crï¿½ation et ajout des treeviews dans des scrolledWindows
			scrolled_win = ScrolledWindow.new.add(treeview)
			# Affichage ou non des scrollBars
			scrolled_win.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)
			
			# Ajoute dans chaque page des onglets du notebook une ScrolledWindow
			nb.append_page(scrolled_win, tabLabel[i])
		end
		
		boutRetour = Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		@contenu.pack_start(labelInfo, false, false)
		@contenu.add(nb)
		@contenu.pack_start(boutRetour, false, false)
		
		@contenu.set_border_width(20)
		
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end
	
	
	##
	# Rempli une ListStore par l'intermï¿½diaire de la liste de joueur passï¿½e en paramï¿½tre.
	# == Parameters: 
   #* <b>listeJoueur :</b> un tableau de joueur
	#
	def remplirListStore(listeJoueur)
		# Crï¿½er un nouveau tree model comprenant 6 colonnes
		store = ListStore.new(String, Integer, Integer, Integer, String, Integer)
		
		# Ajoute toutes les statistiques des joueurs @contenues dans "listeJoueur" ï¿½ la ListStore
		listeJoueur.each_with_index do |e, i|
			colonne = store.append
			
			colonne[0] = listeJoueur[i][0]	# Correspond au nom du joueur
			colonne[1] = listeJoueur[i][1]	# Correspond au nombre d'ennemis tuï¿½s pas le joueur
			colonne[2] = listeJoueur[i][2]	# Correspond ï¿½ la distance totale parcourue par le joueur
			colonne[3] = listeJoueur[i][3]	# Correspond ï¿½ l'or total accumulï¿½ par le joueur
			dureeTotale = listeJoueur[i][4]	# Correspond au temps de jeu total du joueur en secondes
			dureeMinutes = "%02.0f" % ((dureeTotale % 3600) / 60) # "%02.0f" => affiche 2 chiffres avant la virgule
																				# et 0 aprï¿½s => pour trier les strings correctement
			dureeHeures = dureeTotale / 3600
			colonne[4] = "#{dureeHeures} h #{dureeMinutes} min"
			colonne[5] = listeJoueur[i][5]	# Correspond au score du joueur
		end
		
		return store
	end
	
	
	##
	# Ajoute 6 colonnes au treeview
	# == Parameters: 
   #* <b>treeview :</b> le treeview ï¿½ configurer
	#
	def setup_tree_view(treeview)
	  # Create a new GtkCellRendererText, add it to the tree
	  # view column and append the column to the tree view.
	  renderer = CellRendererText.new
	
	  # Les propriï¿½tï¿½s affectent la colonne entiï¿½re
	  # On utilise Pango pour obtenir le gras
    renderer.weight = Pango::FontDescription::WEIGHT_BOLD
    
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("pseudo"), renderer,  :text => 0)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 0
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	  renderer = CellRendererText.new
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("ennemisTues"), renderer, :text => 1)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 1
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("distanceParcourue"), renderer, :text => 2)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 2
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("orTotal"), renderer, :text => 3)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 3
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("tempsJeu"), renderer, :text => 4)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 4
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("score"), renderer, :text => 5)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 5
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	end
	
	
	##
	# Rempli et retourne une liste de statistiques de joueurs en fonction de la difficultï¿½
	# == Parameters: 
   #* <b>difficulte :</b> une chaine de caractï¿½res permettant de choisir la liste de joueur ï¿½ retourner en fonction de cette difficultï¿½
   #
	def remplirListeJoueur()
		#listeJoueur = Array.new
		c = Classements.new()
		
		if(File.exist?("XMLFile/classements.xml")) # Si le fichier xml correspondant aux classements des joueurs existe
			XmlClassements.lireXml(c)
			#listeJoueur = c.getListeJoueur(difficulte)
		end
		
		#return listeJoueur # La liste est vide si le fichier xml n'existe pas
		return c
	end

	
	##
   # Lorsque le joueur clique sur options, permet de choisir la langue ou d'activer le son 
   #
	def afficherOptions()
    	@fenetreMenu  = Window.new()
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("Options"))
		@fenetreMenu.resize(100,100)
		
		@contenu = VBox.new(true, 10)
		
		maHBoxSon 	= HBox.new(true, 10)
		labelSon 	= Label.new(XmlMultilingueReader.lireTexte("musique?"))
		oui 			= RadioButton.new(XmlMultilingueReader.lireTexte("oui"))
		non 			= RadioButton.new(oui, XmlMultilingueReader.lireTexte("non"))
		
		maHBoxSon.add(labelSon)
		maHBoxSon.add(oui)
		maHBoxSon.add(non)
		
      maHBoxBruitage   = HBox.new(true, 10)
      labelBruitage    = Label.new(XmlMultilingueReader.lireTexte("bruitage?"))
      ouiB             = RadioButton.new(XmlMultilingueReader.lireTexte("oui"))
      nonB             = RadioButton.new(ouiB, XmlMultilingueReader.lireTexte("non"))
        
      maHBoxBruitage.add(labelBruitage)
      maHBoxBruitage.add(ouiB)
      maHBoxBruitage.add(nonB)
		
		maHBoxLangue 	= HBox.new(true, 10)
		labelLangue 	= Label.new(XmlMultilingueReader.lireTexte("langue") + " : ")
		listeLangue 	= ComboBox.new(true)
		listeLangue.insert_text(0, XmlMultilingueReader.lireTexte("francais"))
		listeLangue.insert_text(1, XmlMultilingueReader.lireTexte("anglais"))
		listeLangue.active=(0)
		
		maHBoxLangue.add(labelLangue)
		maHBoxLangue.add(listeLangue)
		
		boutValider = Button.new(XmlMultilingueReader.lireTexte("valider"))
		
		@contenu.add(maHBoxSon)
      @contenu.add(maHBoxBruitage)
		@contenu.add(maHBoxLangue)
		@contenu.add(boutValider)
		@contenu.set_border_width(20)
		
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all
		
      @controleur.validerOptionsCreer(boutValider, oui, non, ouiB, nonB, listeLangue, @fenetreMenu)
      @controleur.destroyMenuCreer(@fenetreMenu)
		
	end

	
	
	##
   # Lorsque le joueur clique sur aide, affiche l'aide sur le jeu
   #
	def afficherAide()
    	@fenetreMenu  = Window.new(Gtk::Window::TOPLEVEL)
		@fenetreMenu.set_title(XmlMultilingueReader.lireTexte("Aide"))
		
		#@fenetreMenu.set_resizable(false)
		#@fenetreMenu.set_size_request(500, 500)
		#@fenetreMenu.resize(300, 500)
		@fenetreMenu.set_height_request(500)
		
		@contenu = VBox.new(false, 10)
		
		texteAide = ""
		
		fichier = File.open("aide.txt", "r")
		fichier.each_line { |ligne|
			texteAide = texteAide + ligne
		}
		fichier.close		
		
		labelAide = Label.new()
		labelAide.set_markup(texteAide)
		labelAide.wrap = true
		
		#textview = TextView.new
		#textview.buffer.text = texteAide
		#textview.wrap_mode = TextTag::WRAP_WORD
		#textview.left_margin = 10
		#textview.right_margin = 10
		
		scrolled_win = ScrolledWindow.new
		#scrolled_win.add(textview)
		scrolled_win.add_with_viewport(labelAide)
		# Affichage ou non des scrollBars
		scrolled_win.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)
		
		boutRetour = Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		@contenu.add(scrolled_win)
		@contenu.pack_start(boutRetour, false, false)
		@contenu.set_border_width(20)
		
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end

	
end

#Test
#m = MenuJeu.creer(false);
#m2 = MenuJeu.creer(true);
