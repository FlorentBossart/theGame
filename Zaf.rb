#!/usr/bin/env ruby

##
# Fichier            : Zaf.rb
# Auteur            : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la zone d'affichage qui est en bas de la vue
#

require 'gtk2'
require './Console.rb'
require './Jauges.rb'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './XMLReader/XmlMultilingueReader.rb'

#affiche console + jauges

class Zaf < Gtk::Frame
  @console
  @jauges
  @referencesGraphiques
  def initialize()
    super();
    #Gtk.init();
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
    @console = Console.new();
    #@jauges = Jauges.new(0,5,50,80,100,1);
    @jauges = Jauges.new();
    initInterface();

    #Gtk.main();

  end

  def initInterface()

    hbox = Gtk::HBox.new(true, 2);

    #ajout console
    hbox.add(@console);
    hbox2 = Gtk::HBox.new(true, 4);
    tabNiveau = Gtk::Table.new(1,6,true)
    
   

    vbox = Gtk::VBox.new(true,4);
    vbox.add(hbox2);

    #ajout jauges
    hbox2.add(@jauges.getJaugeNbRepos());
    hbox2.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique("repos")));
    hbox2.add(@jauges.getJaugeOr());
    hbox2.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique("icone or")));
    vbox.add(@jauges.getJaugeEnergie());
    vbox.add(@jauges.getJaugeExperience());
    tabNiveau.attach(Gtk::Label.new(XmlMultilingueReader.lireTexte("niveau") + " : "),2,3,0,1)
    tabNiveau.attach(@jauges.getNiveau(),3,4,0,1)
    vbox.add(tabNiveau);
    
    
    hbox.add(vbox);

    add(hbox);

    show_all();

  end

  def majZaf(joueur)
    @jauges.majJauge(joueur)
    while(!joueur.modele.notifications.empty?)
      @console.afficherTexte(joueur.modele.lireNotification())
    end
  end

end

#Zaf.new();