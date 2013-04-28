require 'gtk2'
require './ReferencesGraphiques.rb'
require './XmlRefGraphiquesReader.rb'
require './Controller.rb'




class InterfaceModal
  
  @referencesGraphiques
  def initialize()
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
    initInterface();
  end
  
  def initInterface()
    if(@vue.modele.joueur.casePosition.presenceAides)
      listeElements=@vue.modele.joueur.casePosition.listeElements()
      dialog = Gtk::Dialog.new("Interaction", @vue,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT)

      # Ensure that the dialog box is destroyed when the user responds.
      dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
      dialog.vbox.add(Gtk::Label.new("Veuillez choisir une interaction"))
      listeElements.each{ |element| 

        }
      dialog.vbox.add(Gtk::Button.new("REPOS"))
      dialog.vbox.add(Gtk::Button.new("REPOS"))
      dialog.show_all
    else
                # Create the dialog
          dialog = Gtk::Dialog.new("My dialog", @vue,
                         Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
                         [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT],
                         [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

      # Ensure that the dialog box is destroyed when the user responds.
      dialog.signal_connect('response') { dialog.destroy }

      # Add the message in a label, and show everything we've added to the dialog.
      dialog.vbox.add(Gtk::Label.new("Il n'y a rien a faire sur cette emplacement !"))
      dialog.vbox.add(Gtk::Button.new("REPOS"))
      dialog.vbox.add(Gtk::Button.new("REPOS"))
      dialog.show_all
    end

    
  end

  
end
