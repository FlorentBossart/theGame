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
    vbox = Gtk::VBox.new(true,4);
    vbox.add(hbox2);

    #ajout jauges
    hbox2.add(Gtk::Label.new(@jauges.getJaugeNbRepos().to_s()));
    hbox2.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique("repos")));
    hbox2.add(Gtk::Label.new(@jauges.getJaugeOr().to_s()));
    hbox2.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique("bourse")));
    vbox.add(@jauges.getJaugeEnergie());
    vbox.add(@jauges.getJaugeExperience());
    vbox.add(Gtk::Label.new("Niveau : "+Gtk::Label.new(@jauges.getNiveau().to_s()).text));

    hbox.add(vbox);

    add(hbox);

    show_all();

  end

  def majZaf

  end

end

#Zaf.new();