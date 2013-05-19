#!/usr/bin/env ruby

require 'gtk2'

require 'Modele.rb'
require 'XMLReader/XmlMultilingueReader.rb'
require 'Audio.rb'
#require 'Controller.rb'
#require 'Vue.rb'

#Gtk.init

XmlMultilingueReader.setLangue("FR")

# Remplissage des bibliothèque
Modele.initialisationBibliotheques()

Audio.load()

#difficulte = BibliothequeDifficulte.getDifficulte("Novice")
#pseudo = "Fake"

#Cr�ation vue
vue = Vue.new

#Cr�ation modele
modele = Modele.creer(vue,nil,nil)

#Cr�ation controlleur
controleur = Controller.creer(modele, vue)

vue.defM(modele)
vue.defC(controleur)
#modele.initialiseToi()

#Cr�ation menu
menu = MenuJeu.creer(false, modele, controleur)
vue.menu = menu


menu.afficherMenu()
Gtk.main()
#vue.initInterface(true)



