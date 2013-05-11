#!/usr/bin/env ruby 

## 
# Fichier           : InteractionModal.rb 
# Auteur           : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe représente une InteractionModal. Un InteractionModal est défini par : 
# * Une vue auquel il est lié
# * Des references Graphiques representant la base de donnée image
# * Un modele sur lequel l'objet ira chercher les informations
# 


require 'gtk2'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './XMLReader/XmlMultilingueReader.rb'
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
  
  ## 
  # Crée une nouvelle InteractionModal à partir des informations passées en paramètre. 
  # 
  # == Parameters: 
  # * <b>vue :</b> represente la vue auquel la fenetre de CombatModal est attachée
  # * <b>modele :</b> represente le modele sur lequel l'objet ira chercher les informations
  # 
  def initialize(modele,vue)
    @vue=vue
    @modele=modele
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)
  end
  
  
  ## 
  # Instancie une InterfaceModal
  # 
  # == Parameters: 
  # * <b>vue :</b> representant la vue auquel la fenetre de CombatModal est attachée
  # * <b>modele :</b> represente le modele sur lequel l'objet ira chercher les informations
  # 
  def InteractionModal.creer(modele,vue)
    new(modele,vue)
  end
  
  
  ## 
  # Cree un PopUp affichant les choix disponibles sur la case actuelle du joueur
  # affiche qu'il n'y a rien a faire s'il n'y a rien sur la case
  # 
  def majInteractionModal()
    tooltips = Gtk::Tooltips.new
    if(@modele.joueur.casePosition.presenceAides?())
      
      listeElements=@modele.joueur.casePosition.listeElements()

      # Creation du popup
      dialog = Gtk::Dialog.new(XmlMultilingueReader.lireTexte("popupInteraction"), @vue.window,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT)
      dialog.signal_connect('response') { dialog.destroy }
      dialog.vbox.add(Gtk::Label.new(XmlMultilingueReader.lireTexte("choixInteraction")))
      listeElements.each{ |element| 
        
        button=Gtk::Button.new()
        image= Gtk::Image.new()
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(element.getIntitule().downcase))
        pixbufElement=pixbufElement.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
        image.set_pixbuf(pixbufElement)
        button.image = image
        
        
        
        tooltips.set_tip( button, element.to_s, nil )

        @vue.controller.interactionElementCreer(button,element,@modele.joueur,dialog)
        dialog.vbox.add(button)
       }
      dialog.show_all
      dialog.run do |response|
        case response
          when Gtk::Dialog::RESPONSE_ACCEPT
          else
        end
      end

      
    else
       dialog = Gtk::Dialog.new(XmlMultilingueReader.lireTexte("popupInteraction"), @vue.window,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
                         [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
      dialog.signal_connect('response') { dialog.destroy }
      dialog.vbox.add(Gtk::Label.new(XmlMultilingueReader.lireTexte("nothingToDoInteraction")))
      dialog.show_all
    end
  end
  
  
  ## 
  # Retourne une chaîne de caractères  permettant l'identification de l'objet. 
  # 
  def to_s
    return XmlMultilingueReader.lireTexte("interactionModal")
  end
  
end
