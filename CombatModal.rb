require 'gtk2'
require './ReferencesGraphiques.rb'
require './XmlRefGraphiquesReader.rb'
require './Controller.rb'




class CombatModal
  private_class_method :new
  @vue
  @referencesGraphiques
  def initialize(vue,modele)
    @vue=vue
    @modele=modele
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
  end
  
  
  def CombatModal(vue,modele)
    new(vue,modele)
  end
  
  
  def majEquipementDefensif()
    tooltips = Gtk::Tooltips.new
    listeArmure=Array.new()
    for i in @modele.joueur.inventaire.items
      if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == "armure")
        listeArmure.push(i)
      end
    end
    dialog = Gtk::Dialog.new("Combat", controller.vue,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

      # Ensure that the dialog box is destroyed when the user responds.
    dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
    dialog.vbox.add(Gtk::Label.new("Un ennemi approche, voulez-vous enfiler une armure?"))
    listeArmure.each{ |item|
        #Faut que je vois pour l'affichage des item, bouton image + un string a coté ou juste un string
        button=Gtk::EventBox.new.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique(element.intitule)))
        tooltips.set_tip( button, element.to_s, nil )
      
        #version juste textuelle, peut etre y ajouter les stats de l'item en question
       # button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")
        

        @vue.controller.interactionElementCreer(button,item,@modele.joueur);
        dialog.vbox.add(button)
       }
   dialog.show_all

  end
  
  def majEquipementOffensif()
    tooltips = Gtk::Tooltips.new
    listeArme=Array.new()
    for i in @modele.joueur.inventaire.items
     if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == "arme")
       listeArmure.push(i)
     end
    end
    dialog = Gtk::Dialog.new("Combat", controller.vue,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
            [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

    # Ensure that the dialog box is destroyed when the user responds.
    dialog.signal_connect('response') { dialog.destroy }

    # Add the message in a label, and show everything we've added to the dialog.
    dialog.vbox.add(Gtk::Label.new("Un ennemi approche, voulez-vous utiliser une arme?"))
    listeArmure.each{ |item|
      #Faut que je vois pour l'affichage des item, bouton image + un string a coté ou juste un string
      button=Gtk::EventBox.new.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique(element.intitule)))
      tooltips.set_tip( button, element.to_s, nil )
      
      #version juste textuelle, peut etre y ajouter les stats de l'item en question
      #button=Gtk::Button.new(item.intitule()+" "+item.typeEquipable.pourcentageProtection()+"energie")

      @vue.controller.interactionElementCreer(button,item,@modele.joueur);
      dialog.vbox.add(button)
    }
    dialog.show_all

  end

  
end
