require 'gtk2'
require './ReferencesGraphiques.rb'
require './XmlRefGraphiquesReader.rb'
require './Controller.rb'




class InterfaceModal
  
  @vue
  @referencesGraphiques
  def initialize(vue)
    @vue=vue
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
    initInterface();
  end
  
  
  def InterfaceModal(vue)
    new(vue)
  end
  
  
  def initInterface()
    if(@vue.modele.joueur.casePosition.presenceAides())
      listeElements=@vue.modele.joueur.casePosition.listeElements()
      dialog = Gtk::Dialog.new("Interaction", controller.vue,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT)

      # Ensure that the dialog box is destroyed when the user responds.
      dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
      dialog.vbox.add(Gtk::Label.new("Veuillez choisir une interaction"))
      listeElements.each{ |element| 
        #Faut que je vois pour l'affichage des elements, mais pas sur d'afficher vraiment des images pour le choix guerisseur etc, l'intitulé pourrait suffire ?
        #button=Gtk::EventBox.new.add(Gtk::Image.new(@referencesGraphiques.getRefGraphique(element.intitule)))
        
        #version juste textuelle
        button=Gtk::Button.new(element.intitule())

        Controller::InteractionElement.creer(button,elem);
        dialog.vbox.add(button)
       }
      dialog.show_all
    else
                # Create the dialog
          dialog = Gtk::Dialog.new("Interaction", @vue,
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
