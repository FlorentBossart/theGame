#!/usr/bin/env ruby

require 'gtk2'

require 'Modele.rb'
require 'XMLReader/XmlMultilingueReader.rb'
require 'Audio.rb'
require 'Controller.rb'

Gtk.init

#XmlMultilingueReader.setLangue("FR")

# Remplissage des bibliothÃ¨que
#Modele.initialisationBibliotheques()

Audio.load()

#Création vue
vue = Vue.new

#Création modele
modele = Modele.creer(vue, nil, nil)

#Création controlleur
controleur = Controller.creer(modele, vue)

#Création menu
menu = MenuJeu.creer(false, modele, controleur)
vue.defMenu(menu)

menu.afficherMenu()
Gtk.main()


