#!/usr/bin/env ruby

## 
# Fichier        : MenuJeu.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de cr�er le menu du jeu et contient :
#* Une fen�tre repr�sentant la fenetre du menu 
#* Un bool�en indiquant si le joueur est en cours de jeu ou non, ce qui modifiera les boutons du menu en cons�quence
#* Un contenu repr�sent� par une box et qui contient les �l�ments de chaque "sous-menu" (nouvelle partie, classement, ...)
# 

require 'gtk2'
require 'sdl'

require 'VUE/Classements.rb'
require 'XMLReader/XmlClassements.rb'
require 'XMLReader/XmlMultilingueReader.rb'

require 'VUE/BibliothequeSlot.rb'
require 'VUE/YamlSlot.rb'
require 'VUE/Slot.rb'

# On inclu le module Gtk, cela �vite de pr�fixer les classes par Gtk::
include Gtk
include Gtk::RC

class MenuJeu
	
	@fenetreMenu
	@isInGame
	@contenu
	@controleur
	@modele
	
	attr_accessor :fenetreMenu
	
	attr_reader :contenu, :isInGame
	
	private_class_method :new
	
	def initialize(isEnJeu, modele, controleur)
		
		@isInGame 		= isEnJeu
		@controleur 	= controleur
		@modele 			= modele
		
		#Configuration aspect graphique de l'interface par un Gtkrc
		Gtk::RC.parse("gtkrc.rc")
		
		#@fenetreMenu 	= Gtk::Window.new()
		#@fenetreMenu.set_default_size(300,300)
		
		#@fenetreMenu.set_default_size(669,534)
		
	end
	
	
	##
   # Cr�e un nouveau Menu
   #
   # == Parameters:
   # isEnJeu : un bool�en indiquant si le joueur est en jeu ou non
   #
	def MenuJeu.creer(isEnJeu, modele, controleur)
		return new(isEnJeu, modele, controleur)
	end
	
	
	##
   # Vide la fen�tre de tous ses composants.
   #
   # == Parameters:
   # box : une boite � supprimer de la fenetre
   #
	def viderFenetre(box)
		@fenetreMenu.remove(box)
	end
	
	
	##
   # Initialise la fen�tre du menu avec les boutons n�cessaires
   #
	def afficherMenu()
	  	fenMenuPrincipal = Window.new()
	  	fenMenuPrincipal.name = "fenMenuPrincipal" # R�f�rence pour le fichier gtkrc.rc
		fenMenuPrincipal.set_title(XmlMultilingueReader.lireTexte("nomMenu"))
		
		#fenMenuPrincipal.set_default_size(669,534) # Marche pas !
		fenMenuPrincipal.set_width_request(669)
		fenMenuPrincipal.set_height_request(534)
		fenMenuPrincipal.set_resizable(false)
	
		#@contenu = VBox.new(false, 6)
		@contenu = VBox.new(false, 0)
		
		# Cr�ation des boutons
		if(@isInGame == false)
						
			ebNewPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("NewPartie")))
			ebNewPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebChargerPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("ChargerPartie")))
			ebChargerPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebClassement = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Classement")))
			ebClassement.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebOptions = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Options")))
			ebOptions.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebAide = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Aide")))
			ebAide.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebQuitter = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Quitter")))
			ebQuitter.events = Gdk::Event::BUTTON_PRESS_MASK
			
			@contenu.add(ebNewPartie)
			@contenu.add(ebChargerPartie)
			@contenu.add(ebClassement)
			@contenu.add(ebOptions)
			@contenu.add(ebAide)
			@contenu.add(ebQuitter)
			
=begin
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
=end
			if(XmlMultilingueReader.getLangue() == "FR")
				@contenu.set_spacing(6)
				align = Alignment.new(0.85, 0.9, 0, 0)
			else
				@contenu.set_spacing(6)
				align = Alignment.new(0.8, 0.9, 0, 0)
			end
		else
			ebContinuerPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("ContinuerPartie")))
			ebContinuerPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebNewPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("NewPartie")))
			ebNewPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebChargerPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("ChargerPartie")))
			ebChargerPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebSauvegarderPartie = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("SauvegarderPartie")))
			ebSauvegarderPartie.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebClassement = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Classement")))
			ebClassement.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebOptions = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Options")))
			ebOptions.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebAide = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Aide")))
			ebAide.events = Gdk::Event::BUTTON_PRESS_MASK
			
			ebQuitter = EventBox.new.add(Label.new(XmlMultilingueReader.lireTexte("Quitter")))
			ebQuitter.events = Gdk::Event::BUTTON_PRESS_MASK
			
			@contenu.add(ebContinuerPartie)
			@contenu.add(ebNewPartie)
			@contenu.add(ebChargerPartie)
			@contenu.add(ebSauvegarderPartie)
			@contenu.add(ebClassement)
			@contenu.add(ebOptions)
			@contenu.add(ebAide)
			@contenu.add(ebQuitter)
=begin			
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
=end			
			if(XmlMultilingueReader.getLangue() == "FR")
				align = Alignment.new(0.85, 0.9, 0, 0)
			else
				align = Alignment.new(0.8, 0.9, 0, 0)
			end
		end
		
		align.add(@contenu)
		fenMenuPrincipal.add(align)
   	fenMenuPrincipal.set_window_position Gtk::Window::POS_CENTER
		fenMenuPrincipal.show_all
		
		if(@isInGame == true)
			ebContinuerPartie.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
			ebContinuerPartie.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
			@controleur.continuerPartieCreer(ebContinuerPartie,fenMenuPrincipal)
			
			ebSauvegarderPartie.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
			ebSauvegarderPartie.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
			@controleur.sauvegarderPartieCreer(ebSauvegarderPartie,fenMenuPrincipal)
		end
		
		ebNewPartie.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebNewPartie.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.nouvellePartieCreer(ebNewPartie,fenMenuPrincipal)
		
		ebChargerPartie.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebChargerPartie.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.chargerPartieCreer(ebChargerPartie,fenMenuPrincipal)
		
		ebClassement.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebClassement.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.classementCreer(ebClassement,fenMenuPrincipal)
		
		ebOptions.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebOptions.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.optionsCreer(ebOptions,fenMenuPrincipal)
		
		ebAide.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebAide.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.aideCreer(ebAide,fenMenuPrincipal)
		
		ebQuitter.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
		ebQuitter.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
		@controleur.quitterPartieCreer(ebQuitter,fenMenuPrincipal)
		
			
		@controleur.destroyMenuCreer(fenMenuPrincipal)
=begin
		@controleur.nouvellePartieCreer(boutNewPartie,fenMenuPrincipal)		
		@controleur.chargerPartieCreer(boutChargerPartie,fenMenuPrincipal)
		@controleur.classementCreer(boutClassement,fenMenuPrincipal)
		@controleur.optionsCreer(boutOptions,fenMenuPrincipal)
		@controleur.aideCreer(boutAide,fenMenuPrincipal)
		@controleur.quitterPartieCreer(boutQuitter,fenMenuPrincipal)
		@controleur.destroyMenuCreer(fenMenuPrincipal)
=end
		
	end
	
	
	##
   # Lorsque le joueur clique sur nouvelle partie, affiche un champ pour le nom du joueur, 
   # des boutons radio pour le choix de difficult� et un bouton lancer partie
   #
	def afficherNouvellePartie()		
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
		
    	@fenetreMenu.set_window_position Gtk::Window::POS_CENTER
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
		# Tableau contenant des EventBox pouvant �tre cliqu�es pour charger une partie
		tabEventBox = Array.new
		
		# Tableau contenant les slots de sauvegarde
		tabSlot = Array.new
		
		# Remplissage des frames contenant les diff�rentes EventBox
		# Ces EventBox contiennent elles-m�mes des infos (@contenus dans le fichier yaml) sur le slot de sauvegarde en question
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
							" | " + XmlMultilingueReader.lireTexte("difficulte") + " : " + XmlMultilingueReader.lireTexte(diff.downcase) + 
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
		
		# C'est une fois que les eventBox sont cr�es et ajout�es � la fenetre qu'elles sont associ�es � une Gdk::Window (et non Gtk::Window)
		# On peut donc appeler eventbox.window pour pouvoir modifier la zone correspondante � cette eventBox
		tabEventBox.each_with_index{|eb, index|
			eb.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
			if(tabSlot[index] != nil)	# Si le slot "existe"
				eb.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1) # Change le curseur en forme de main
				eb.signal_connect('button_press_event') { 
					puts " Chargement du slot" + (index+1).to_s 
					
					modeleCharger = tabSlot[index].modele
					Modele.majCpt(modeleCharger.compteurTour)
					
					modeleCharger.joueur.tempsTotal = tabSlot[index].temps # On reprend le temps de la save pour l'ajouter au temps de la session de jeu en cours
					puts "temps de jeu session d'avant : " + modeleCharger.joueur.tempsTotal.to_s
					modeleCharger.joueur.dateDebutJeu = Time.now
					puts "Debut du temps de jeu le " + modeleCharger.joueur.dateDebutJeu.to_s
					
					@fenetreMenu.destroy
					
					if(@isInGame == true)
						#Destruction ancienne vue partie
						@modele.vue.window.destroy
						puts "Destroy partie"
					end
					
					# Creation de la vue charg�e
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
		
		
    @fenetreMenu.set_window_position Gtk::Window::POS_CENTER
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
		# Tableau contenant des EventBox pouvant �tre cliqu�es pour sauvegarder une partie
		tabEventBox = Array.new
		
		# Tableau contenant les slots de sauvegarde
		tabSlot = Array.new
		
		# Remplissage des frames contenant les diff�rentes EventBox
		# Ces EventBox contiennent elles-m�mes des infos (contenus dans le fichier yaml) sur le slot de sauvegarde en question
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
							" | " + XmlMultilingueReader.lireTexte("difficulte") + " : " + XmlMultilingueReader.lireTexte(diff.downcase) + 
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
				
		# C'est une fois que les eventBox sont cr�es et ajout�es � la fenetre qu'elles sont associ�es � une Gdk::Window (et non Gtk::Window)
		# On peut donc appeler eventbox.window pour pouvoir modifier la zone correspondante � cette eventBox
		tabEventBox.each_with_index{|eb, index|
			eb.realize # Cr�er la fenetre GDK (Gdk::Window) associ�es au widget
			eb.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND2) # Change le curseur en forme de main
			
			eb.signal_connect('button_press_event') {
				puts "\tSauvegarde sur le slot" + (index+1).to_s 
				YamlSlot.ecrireYaml("slot" + (index+1).to_s + ".yaml", @modele)
				
				@fenetreMenu.destroy
				
				# MAJ de l'affichage des slots de sauvegarde
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
   # en r�cup�rant les donn�es du fichier XML
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
		tabLabel[0] = Label.new("Novice")
		tabLabel[1] = Label.new("Moyen")
		tabLabel[2] = Label.new("Expert")
		
		# Rempli toutes les listes de joueurs de toutes les difficultes : retourne un classement
		c = remplirListeJoueur()		

		  0.upto(2) do |i|
			# Cr�ation des treeView
			treeview = TreeView.new
			
			# Ajout des param�tres de rendu aux treeViews
			setup_tree_view(treeview)
			
			# Cr�ation et remplissage des ListStore
			store = remplirListStore(c.getListeJoueur(tabLabel[i].text))
			
			# Ajoute chacun des tree model au tree view correspondant
			treeview.model = store
			
			# Cr�ation et ajout des treeviews dans des scrolledWindows
			scrolled_win = ScrolledWindow.new.add(treeview)
			# Affichage ou non des scrollBars
			scrolled_win.set_policy(Gtk::POLICY_NEVER, Gtk::POLICY_AUTOMATIC)
			
			# Pour traduire les textes des onglets
			texteOnglet = XmlMultilingueReader.lireTexte(tabLabel[i].text.downcase)
			tabLabel[i].text = texteOnglet
			
			# Ajoute dans chaque page des onglets du notebook une ScrolledWindow
			nb.append_page(scrolled_win, tabLabel[i])
		end
		
		boutRetour = Button.new(XmlMultilingueReader.lireTexte("retourMenu"))
		
		@contenu.pack_start(labelInfo, false, false)
		@contenu.add(nb)
		@contenu.pack_start(boutRetour, false, false)
		
		@contenu.set_border_width(20)
    @fenetreMenu.set_window_position Gtk::Window::POS_CENTER
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end
	
	
	##
	# Rempli une ListStore par l'interm�diaire de la liste de joueur pass�e en param�tre.
	# == Parameters: 
   #* <b>listeJoueur :</b> un tableau de joueur
	#
	def remplirListStore(listeJoueur)
		# Cr�er un nouveau tree model comprenant 6 colonnes
		store = ListStore.new(String, Integer, Integer, Integer, String, Integer)
		
		# Ajoute toutes les statistiques des joueurs contenues dans "listeJoueur" � la ListStore
		listeJoueur.each_with_index do |e, i|
			colonne = store.append
			
			colonne[0] = listeJoueur[i][0]	# Correspond au nom du joueur
			colonne[1] = listeJoueur[i][1]	# Correspond au nombre d'ennemis tu�s pas le joueur
			colonne[2] = listeJoueur[i][2]	# Correspond � la distance totale parcourue par le joueur
			colonne[3] = listeJoueur[i][3]	# Correspond � l'or total accumul� par le joueur
			dureeTotale = listeJoueur[i][4]	# Correspond au temps de jeu total du joueur en secondes
			#colonne[4] = @modele.joueur.convertirTemps(dureeTotale) # Renvoi une chaine sous la forme "h min sec"
			colonne[4] = @modele.convertirTemps(dureeTotale) # Renvoi une chaine sous la forme "h min sec"
			colonne[5] = listeJoueur[i][5]	# Correspond au score du joueur
		end
		
		store.set_sort_column_id(5, SORT_DESCENDING)
		
		return store
	end
	
	
	##
	# Ajoute 6 colonnes au treeview
	# == Parameters: 
   #* <b>treeview :</b> le treeview � configurer
	#
	def setup_tree_view(treeview)
	  # Create a new GtkCellRendererText, add it to the tree
	  # view column and append the column to the tree view.
	  renderer = CellRendererText.new
	
	  # Les propri�t�s affectent la colonne enti�re
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
	  
	  renderer = CellRendererText.new
	  renderer.weight = Pango::FontDescription::WEIGHT_BOLD
	  column   = TreeViewColumn.new(XmlMultilingueReader.lireTexte("score"), renderer, :text => 5)
	  # ======= Pour pouvoir trier la colonne
	  column.sort_indicator=true
	  column.sort_column_id = 5
	  # ======= Fin du tri
	  treeview.append_column(column)
	  
	end
	
	
	##
	# Rempli et retourne une liste de statistiques de joueurs en fonction de la difficult�
	# == Parameters: 
   #* <b>difficulte :</b> une chaine de caract�res permettant de choisir la liste de joueur � retourner en fonction de cette difficult�
   #
	def remplirListeJoueur()
		c = Classements.new()
		
		if(File.exist?("XMLFile/classements.xml")) # Si le fichier xml correspondant aux classements des joueurs existe
			XmlClassements.lireXml(c)
		end
		
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
    @fenetreMenu.set_window_position Gtk::Window::POS_CENTER
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
    @fenetreMenu.set_window_position Gtk::Window::POS_CENTER
		@fenetreMenu.add(@contenu)
		@fenetreMenu.show_all

		@controleur.retourCreer(boutRetour,@fenetreMenu)
		@controleur.destroyMenuCreer(@fenetreMenu)
	end

	
end

#Test
#m = MenuJeu.creer(false);
#m2 = MenuJeu.creer(true);