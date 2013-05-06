#!/usr/bin/env ruby 

## 
# Fichier            : Vue.rb 
# Auteur            : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe représente l'affichage du jeu dan sa totalité 
# 
require 'gtk2'
require './Zaf.rb'
require './ZoneCtrl.rb'
require './Carte.rb'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './InteractionModal.rb'
require './CombatModal.rb'
require './PopUp.rb'

class Vue

  @vue; #affichage carte
  @zaf;
  @zoneCtrl;
  @carte; #la classe carte
  @referencesGraphiques; #fichier xml des images
  @carteVue; #tableau pour affichager la carte
  @hauteurAfficheCarte; #hauteurVisible
  @largeurAfficheCarte; #largeurVisible
  @modele
  @controller
  @x; #coordonné actuel
  @y; #coordonné actuel
  @combatModal
  @interactionModal
  @popUp

  attr_accessor :x ,:y;
  def initialize()
    #Gtk.init();
    #@carteVue = Modele.carte;
    #initInterface();
    #Gtk.main();

  end

  def defM(modele)
    @modele = modele
  end

  def defC(controller)
    @controller=controller
  end

  def initInterface()
    Gtk.init();

    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)

    @hauteurAfficheCarte = 11
    @largeurAfficheCarte = 23
    #matrice de stockage
    @vue = Array.new(@hauteurAfficheCarte){|x|Array.new(@largeurAfficheCarte ){|y|Gtk::Image.new()}}
    @zaf = Zaf.new()
    @zoneCtrl = ZoneCtrl.creer(@vue,@controller)
    @carte = @modele.carte
    @popUp=PopUp.creer(self)
    @interactionModal=InteractionModal.creer(@modele,self)
    @combatModal=CombatModal.creer(self,@modele)

    window = Gtk::Window.new()
    window.signal_connect('destroy') {
      Gtk.main_quit()
    }

    #tableau pour le bas de la fenêtre
    tabBot = Gtk::Table.new(1,3,true)

    tabBot.attach(@zaf,0,2,0,1)
    tabBot.attach(@zoneCtrl,2,3,0,1)

    #tableau pour afficher la carte
    @carteVue = Gtk::Table.new(@hauteurAfficheCarte,@largeurAfficheCarte,true)

    vbox = Gtk::VBox.new()

    #initialisation de la carte

    initCarte(@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2,@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2)
    vbox.add(@carteVue)
    vbox.add(tabBot)

    window.set_resizable(false)
    window.add(vbox)

    window.set_title("THE GAME")

    window.show_all()

    Gtk.main();
  end

  def initCarte(debutX,debutY)
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carteVue.attach(@vue[x][y],y,y+1,x,x+1)
      end
    end

    afficheCarte(debutX,debutY)
  end

  def afficheCarte(debutX,debutY)
    @x=debutX
    @y=debutY

    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        if(@carte.getCaseAt(x+debutX,y+debutY).joueur!=nil)
          @vue[x][y].file=((@referencesGraphiques.getRefGraphique(@carte.getCaseAt(x+debutX,y+debutY).joueur().getIntitule().downcase)))
        elsif(!@carte.getCaseAt(x+debutX,y+debutY).listeEnnemis.empty?())
          @vue[x][y].file=((@referencesGraphiques.getRefGraphique("mechant")))
        else
          @vue[x][y].file=((@referencesGraphiques.getRefGraphique(@carte.getCaseAt(x+debutX,y+debutY).getIntitule().downcase)))
        end
      end
    end
  end

  def getZaf()
    return @zaf
  end

  def actualiser
    afficheCarte(@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2,@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2)
  end

end

