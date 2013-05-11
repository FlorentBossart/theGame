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
    popUp=PopUp.creer("Vous allez combattre un #{ennemi.getIntitule()} de niveau #{ennemi.niveau} ayant une énergie de #{ennemi.energie}.")
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
    
    dialog = Gtk::Dialog.new("Combat", @vue.window,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new("Un ennemi approche, voulez-vous enfiler une armure?"))
      
    listeArmure.each{ |item|
        image = Gtk::Image.new(@referencesGraphiques.getRefGraphique(item.getIntitule()))
        button=Gtk::Button.new()
        button.image = image
        tooltips.set_tip( button, element.to_s, nil )
        #version juste textuelle, peut etre y ajouter les stats de l'item en question
       # button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")

        @vue.controller.equiperItemCreer(button,item,@modele.joueur)
        dialog.vbox.add(button)
       }
   dialog.show_all

  end
  
  
  ## 
  # Cree un PopUp contenant des boutons liés aux objets equipable offensifs
  #  
  def majEquipementOffensif()
    tooltips = Gtk::Tooltips.new
    listeArme=Array.new()
    
    for i in @modele.joueur.inventaire.items
     if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARME)
       listeArmure.push(i)
     end
    end
    
    dialog = Gtk::Dialog.new("Combat", @vue.window,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
            [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
    dialog.signal_connect('response') { dialog.destroy }
    dialog.vbox.add(Gtk::Label.new("Un ennemi approche, voulez-vous utiliser une arme?"))
      
    listeArmure.each{ |item|
      image = Gtk::Image.new(@referencesGraphiques.getRefGraphique(item.getIntitule()))
      button=Gtk::Button.new()
      button.image = image
      tooltips.set_tip( button, element.to_s, nil )
      
      #version juste textuelle, peut etre y ajouter les stats de l'item en question
      #button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")

      @vue.controller.equiperItemCreer(button,item,@modele.joueur)
      dialog.vbox.add(button)
    }
    dialog.show_all

  end
  
  
  ## 
  # Retourne une chaîne de caractères  permettant l'identification de l'objet. 
  # 
  def to_s
    return "Je suis un CombatModal"
  end

  
end

