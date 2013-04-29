require 'gtk2'
require './ReferencesGraphiques.rb'
require './XmlRefGraphiquesReader.rb'



class PopUp
  
  @vue
  @referencesGraphiques
  
  def initialize(vue,message)
    @vue=vue
    @referencesGraphiques = ReferencesGraphiques.new();
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques);
    initInterface(message);
  end
  
  def PopUp.creer(vue,message)
    new(vue,message)
  end
  
  def initInterface(message)
     # Create the dialog
    dialog = Gtk::Dialog.new("Ceci est un message important !", @vue,
             Gtk::Dialog::MODAL | Gtk::Dialog::DESTROY_WITH_PARENT,
             [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

  # Ensure that the dialog box is destroyed when the user responds.
    dialog.signal_connect('response') { dialog.destroy }

    # Add the message in a label, and show everything we've added to the dialog.
    dialog.vbox.add(Gtk::Label.new(message))
    dialog.show_all
  end

  
end
