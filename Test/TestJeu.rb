#!/usr/bin/env ruby

require 'gtk2'

require 'Modele.rb'
require 'XMLReader/XmlMultilingueReader.rb'
require 'Audio.rb'
require 'Controller.rb'

#Gtk.init

XmlMultilingueReader.setLangue("FR")

# Remplissage des bibliothÃ¨que
Modele.initialisationBibliotheques()

Audio.load()

difficulte = BibliothequeDifficulte.getDifficulte("Novice")
pseudo = "Fake"

#Création vue
vue = Vue.new

#Création modele
modele = Modele.creer(vue, difficulte, pseudo)

#Création controlleur
controleur = Controller.creer(modele, vue)

vue.defM(modele)
vue.defC(controleur)
modele.initialiseToi()

#Création menu
menu = MenuJeu.creer(false, modele, controleur)
vue.menu = menu

menu.afficherMenu()

vue.initInterface(true)
#Gtk.main()


