#!/usr/bin/env ruby

require 'gtk2'
require 'MODELE/Modele.rb'
require 'XMLReader/XmlMultilingueReader.rb'
require 'VUE/Audio.rb'

#require 'Controller.rb'
#require 'Vue.rb'

Gtk.init

XmlMultilingueReader.setLangue("EN")

# Remplissage des bibliothèque
Modele.initialisationBibliotheques()

Audio.load()

#difficulte = BibliothequeDifficulte.getDifficulte("Novice")
#pseudo = "Fake"

#Création vue
vue = Vue.new

#Création modele
modele = Modele.creer(vue,nil,nil)

#Création controlleur
controleur = Controller.creer(modele, vue)

vue.defM(modele)
vue.defC(controleur)
#modele.initialiseToi()

#Création menu
menu = MenuJeu.creer(false, modele, controleur)
vue.menu = menu


menu.afficherMenu()
Gtk.main()
#vue.initInterface(true)



