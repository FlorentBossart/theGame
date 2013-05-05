require 'gtk2'
require 'Bibliotheque/ReferencesGraphiques.rb'
class InventaireVue
    @refGraphiques
    @vueInventaire
    @eventInventaire
    @inventaire
    @nbItemH
    @nbItemL
    @imageItemSelected
    @vbox
    @hbox
    @boutonInteraction
    
    def initialize
        @nbItemH = 5
        @nbItemL = 5
        @inventaire = Array.new(@nbItemH){|x| Array.new(@nbItemL){|y| Gtk::Image.new()}}
        @eventInventaire = Array.new(@nbItemH){|x| Array.new(@nbItemL){|y| Gtk::EventBox.new()}}
        
        @imageItemSelected = Gtk::Image.new("img/coloris_noir.png")
        @vbox = Gtk::VBox.new(false,10)
        @hbox = Gtk::HBox.new(false,10)
        @vueInventaire = Gtk::Table.new(@nbItemH,@nbItemL,true);
        @boutonInteraction = Gtk::Button.new("Jeter")
        
        0.upto(@nbItemH-1) do |x|
            0.upto(@nbItemL-1)do |y|
                @inventaire[x][y].file = "img/coloris_noir.png"
                @eventInventaire[x][y].add(@inventaire[x][y])
                
                @vueInventaire.attach(@eventInventaire[x][y],y,y+1,x,x+1);
            end
        end
        @vbox.pack_start(@vueInventaire,true,true,0)
        @vbox.pack_start(@hbox,true,true,0)
        @hbox.pack_start(@imageItemSelected,true,true,0)
        @hbox.pack_start(@boutonInteraction,true,true,0)
    end
    
    def afficherInventaireModeInteractif(joueur,fenetre, mode)
        
        fenetre.add(@vbox)
        #joueur.inventaire.item.each{|x|
        #   @inventaire[x%nbItemH][y/nbItemL].file=((@referencesGraphiques.getRefGraphique(x.intitule.downcase)));
        #}
    end
    
end

Gtk.init()
window = Gtk::Window.new();
window.signal_connect('destroy') {
    Gtk.main_quit();
}
InventaireVue.new.afficherInventaireModeInteractif(nil,window,"Test")
window.show_all
Gtk.main()