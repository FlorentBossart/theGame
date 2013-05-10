"#!/usr/bin/env ruby"

require 'gtk2'

class Console < Gtk::ScrolledWindow

  @console
  
  def initialize()
    super()
    #Gtk.init();
    initInterface();
    #Gtk.main();
  end

  def initInterface()

      #editeur de texte
      @console = Gtk::TextView.new();
      #pas editable
      @console.set_editable(false);
      #masque le curseur
      @console.set_cursor_visible(false);
      #bloque le texte a la largeur de la fenetre
      @console.set_wrap_mode(Gtk::TextTag::WRAP_WORD);
      #scrollbar
      #masque les barres de defilement
      set_policy(Gtk::POLICY_AUTOMATIC,Gtk::POLICY_AUTOMATIC) 
      add(@console);
      buffer=@console.buffer();
      #on ajoute le texte au buffer
      buffer.set_text("Bienvenue dans the game"); 

      show();
      @console.show(); 
  end
  
  
  def afficherTexte(texte)
     nomMarque="finTxt"
     #on recupere le buffer du textview
     buffer=@console.buffer()
     if(buffer.get_mark(nomMarque)!=nil)
         buffer.delete_mark(nomMarque)
     end
     #on ajoute le texte au buffer
     buffer.set_text(buffer.get_text+"\n"+texte)
     iter_fin=buffer.end_iter()
     mark_fin=buffer.create_mark(nomMarque, iter_fin, true)
     @console.scroll_mark_onscreen(mark_fin)
  end
  
  
end

#Console.new;