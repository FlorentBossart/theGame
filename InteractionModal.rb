#!/usr/bin/env ruby 

## 
# Fichier           : CombatModal.rb 
# Auteur           : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe représente un CombatModal. Un CombatModal est défini par : 
# * Une vue auquel il est lié
# * Des references Graphiques representant la base de donnée image
# * Un modele sur lequel l'objet ira chercher les informations
# 


require 'gtk2'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './Controller.rb'

##
# Classe qui instancie un popup permettant de faire un choix sur les interactions possibles
# Depend de la vue
#


class InteractionModal
  private_class_method :new
  @vue
  @modele
  @referencesGraphiques
  def initialize(modele,vue)
    @vue=vue
    @modele=modele
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
  end
  
  
  
  def InteractionModal.creer(modele,vue)
    new(modele,vue)
  end
  
  
  def majInteractionModal()
    tooltips = Gtk::Tooltips.new
    
    if(@modele.joueur.casePosition.presenceAides?())
      
      listeElements=@modele.joueur.casePosition.listeElements()
      # Creation du popup
      dialog = Gtk::Dialog.new("Interaction", $main_application_window,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT)

      # Ensure that the dialog box is destroyed when the user responds.
      dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
      dialog.vbox.add(Gtk::Label.new("Veuillez choisir une interaction"))
      listeElements.each{ |element| 

        button=Gtk::EventBox.new.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique(element.intitule)))
        tooltips.set_tip( button, element.to_s, nil )
        
        #version juste textuelle
       # button=Gtk::Button.new(element.intitule())
        #tooltips.set_tip( button, element.to_s, nil )

        @vue.controller.interactionElementCreer(button,elem,@modele.joueur);
        dialog.vbox.add(button)
       }
      dialog.show_all
      
    else
                # Create the dialog
          dialog = Gtk::Dialog.new("Interaction", $main_application_window,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
                         [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

      # Ensure that the dialog box is destroyed when the user responds.
      dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
      dialog.vbox.add(Gtk::Label.new("Il n'y a rien a faire sur cette emplacement !"))
      dialog.show_all
    end

    
  end

  
end
