#!/usr/bin/env ruby 

## 
# Fichier           : PopUp.rb 
# Auteur           : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe représente un PopUp. Un PopUp est défini par : 
# * Une vue auquel il est lié
# * Des references Graphiques representant la base de donnée image
# 

require 'gtk2'
require './ReferencesGraphiques.rb'
require './XmlRefGraphiquesReader.rb'



class PopUp
  private_class_method :new
  @referencesGraphiques
  @vue
  attr_reader :vue, :referencesGraphiques, :message
  ## 
  # Crée un nouveau PopUp à partir des informations passées en paramètre. 
  # 
  # == Parameters: 
  # * <b>vue :</b> representant la vue auquel la fenetre de CombatModal est attachée
  # 
  def initialize(vue)
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)
    @message=message
  end
  
  
  ## 
  # Instancie un PopUp
  # 
  # == Parameters: 
  # * <b>vue :</b> representant la vue auquel la fenetre de CombatModal est attachée
  #
  def PopUp.creer(vue)
    new(vue)
  end
  
  
  ## 
  # Affiche le PopUp contenant le message
  #
  # == Parameters: 
  # * <b>vue :</b> representant la vue auquel la fenetre de CombatModal est attachée
  #
  def affichePopUp(message)
    dialog = Gtk::Dialog.new("Ceci est un message important !", @vue,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new(message))
    dialog.show_all
  end

  
  ## 
  # Affiche le PopUp contenant un choix entre le menu d'achat ou le menu de vente d'un marchand
  #
  def afficheChoixMarchand()

    dialog = Gtk::Dialog.new("Combat", controller.vue,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new("Veuillez choisir une opération a effectuer avec ce marchand"))
    buttonAchat=Gtk::Button.new("Achat")
    buttonVendre=Gtk::Button.new("Vendre")
    @vue.controller.achatMarchandCreer(buttonAchat)
    dialog.vbox.add(buttonAchat)
    @vue.controller.vendreMarchandCreer(buttonVendre)
    dialog.vbox.add(buttonVendre)

   dialog.show_all
  end
  
end
