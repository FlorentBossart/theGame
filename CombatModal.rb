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


#com
require 'gtk2'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './XMLReader/XmlMultilingueReader.rb'
require './Controller.rb'



class CombatModal
  private_class_method :new
  @vue
  @referencesGraphiques
  @modele
  attr_reader :vue, :referencesGraphiques, :modele
  
  ## 
  # Crée un nouveau CombatModal à partir des informations passées en paramètre. 
  # 
  # == Parameters: 
  # * <b>vue :</b> represente la vue auquel la fenetre de CombatModal est attachée
  # * <b>modele :</b> represente le modele sur lequel l'objet ira chercher les informations
  # 
  def initialize(vue,modele)
    @vue=vue
    @modele=modele
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)
  end
  
  
  ## 
  #Instancie un CombatModal
  # 
  # == Parameters: 
  # * <b>vue :</b> representant la vue auquel la fenetre de CombatModal est attachée
  # * <b>modele :</b> represente le modele sur lequel l'objet ira chercher les informations
  # 
  def CombatModal.creer(vue,modele)
    new(vue,modele)
  end
  
  
  ## 
  # Cree un PopUp avec les informations sur l'ennemi
  # 
  # == Parameters: 
  # * <b>ennemi :</b> reference de l'ennemi dont on veut afficher les informations.
  # 
  def majCombatModal(ennemi)

    str=XmlMultilingueReader.lireTexte("popupCombatEnnemi")
    str.gsub("INTITULE",ennemi.getIntitule()).gsub("NIVEAU",ennemi.niveau().to_s).gsub("ENERGIE",ennemi.energie().to_s)
    @vue.popUp.affichePopUp(str)
  end
  
  
  ## 
  # Cree un PopUp contenant des boutons liés aux objets equipable defensifs
  # 
  def majEquipementDefensif()
    tooltips = Gtk::Tooltips.new
    listeArmure=Array.new()
    
    for i in @modele.joueur.inventaire.items
      if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARMURE)
        listeArmure.push(i)
      end
    end
    
    dialog = Gtk::Dialog.new(XmlMultilingueReader.lireTexte("popupCombat"), @vue.window,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new(XmlMultilingueReader.lireTexte("equipArmure")))
      
    listeArmure.each{ |item|
        button=Gtk::Button.new()
        image= Gtk::Image.new()
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(item.getIntitule().downcase))
        pixbufElement=pixbufElement.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
        image.set_pixbuf(pixbufElement)
        button.image = image
        tooltips.set_tip( button, item.to_s, nil )
        #version juste textuelle, peut etre y ajouter les stats de l'item en question
       # button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")

        @vue.controller.equiperItemCreer(button,item,@modele.joueur,dialog)
        dialog.vbox.add(button)
       }
   dialog.show_all
   dialog.run do |response|
    case response
      when Gtk::Dialog::RESPONSE_ACCEPT
       else
     end
   end
  end
  
  
  ## 
  # Cree un PopUp contenant des boutons liés aux objets equipable offensifs
  #  
  def majEquipementOffensif()
    tooltips = Gtk::Tooltips.new
    listeArme=Array.new()
    
    for i in @modele.joueur.inventaire.items
     if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARME)
       listeArme.push(i)
     end
    end
    
    dialog = Gtk::Dialog.new(XmlMultilingueReader.lireTexte("popupCombat"), @vue.window,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
            [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new(XmlMultilingueReader.lireTexte("equipArme")))
      
    listeArme.each{ |item|
      button=Gtk::Button.new()
      image= Gtk::Image.new()
      pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(item.getIntitule().downcase))
      pixbufElement=pixbufElement.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
      image.set_pixbuf(pixbufElement)
      button.image = image
      tooltips.set_tip( button, item.to_s, nil )
      
      #version juste textuelle, peut etre y ajouter les stats de l'item en question
      #button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")

      @vue.controller.equiperItemCreer(button,item,@modele.joueur,dialog)
      dialog.vbox.add(button)
    }
    dialog.show_all
    dialog.run do |response|
      case response
        when Gtk::Dialog::RESPONSE_ACCEPT
        else
      end
    end

  end
  
  
  ## 
  # Retourne une chaîne de caractères  permettant l'identification de l'objet. 
  # 
  def to_s
    return XmlMultilingueReader.lireTexte("popupCombatModal")
  end

  
end

