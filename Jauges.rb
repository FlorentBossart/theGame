#!/usr/bin/env ruby

##
# Fichier            : Jauges.rb
# Auteur            : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente les jauges du joueur
#

require 'gtk2'
require './XMLReader/XmlMultilingueReader.rb'

class Jauges
  @or #l'or du joueur
  @nbRepos #nombre de repos du joueur
  @niveau #niveau actuel du joueur
  def initialize()
    #Gtk.init();
    @or = Gtk::Label.new("0");
    @nbRepos = Gtk::Label.new("0");
    @niveau = Gtk::Label.new("0");
    initInterface();

    #Gtk.main();

  end

  def initInterface()
    @barExperience = Gtk::ProgressBar.new();
    @barEnergie = Gtk::ProgressBar.new();

    @barExperience.show();
    @barEnergie.show();

  end

  def majJauge(joueur)
    majJaugeOr(joueur.inventaire().capital());
    majJaugeNbRepos(joueur.nombreRepos());
    majJaugeEnergie((joueur.energie()>0)?(joueur.energie):(0),joueur.energieMax());
    majJaugeExperience(joueur.experience(),joueur.experienceSeuil());
    majNiveau(joueur.niveau());
  end

  #mise a jour de l'or
  def majJaugeOr(quantite)
    @or.set_text(quantite.to_s());
  end

  #mise a jour du nomdre de repos
  def majJaugeNbRepos(nbRepos)
    @nbRepos.set_text(nbRepos.to_s());
  end

  #mise a jour  de l'energie
  def majJaugeEnergie(quantite,max)
    @barEnergie.fraction = quantite/max.to_f();
    @barEnergie.set_text(XmlMultilingueReader.lireTexte("energie")+ " : " +sprintf("%.2f",quantite.to_s) + " / " + sprintf("%.2f",max.to_s()));
  end

  #mise a jour de l'experience
  def majJaugeExperience(quantite,max)
    @barExperience.fraction = quantite/max.to_f();
    @barExperience.set_text(XmlMultilingueReader.lireTexte("experience")+ " : " +sprintf("%.2f",quantite.to_s) + " / " + sprintf("%.2f",max.to_s()));
  end

  def majNiveau(niveau)
    @niveau.set_text(niveau.to_s());
  end

  def getNiveau()
    return @niveau;
  end

  #retourne le nombre d'or
  def getJaugeOr()
    return @or
  end

  #retourne le nombre de repos
  def getJaugeNbRepos()
    return @nbRepos;
  end

  #retourne la jauge d'energie
  def getJaugeEnergie()
    return @barEnergie;
  end

  #retourne la jauge d'experience
  def getJaugeExperience()
    return @barExperience
  end

end

