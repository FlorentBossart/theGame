#!/usr/bin/env ruby

require 'gtk2'

require 'Modele.rb'
require 'XMLReader/XmlMultilingueReader.rb'
require 'Audio.rb'
require 'Controller.rb'

Gtk.init

#XmlMultilingueReader.setLangue("FR")

# Remplissage des bibliothèque
#Modele.initialisationBibliotheques()

Audio.load()

#Cr�ation vue
vue = Vue.new

#Cr�ation modele
modele = Modele.creer(vue, nil, nil)

#Cr�ation controlleur
controleur = Controller.creer(modele, vue)

#Cr�ation menu
menu = MenuJeu.creer(false, modele, controleur)
vue.defMenu(menu)

menu.afficherMenu()
Gtk.main()


