require 'gtk2'
class InventaireVue
    @refGraphiques
    @vueInventaire
    @inventaire
    @nbItemH
    @nbItemL
    
    def initialize
        @nbItemH = 5
        @nbItemL = 5
        @inventaire = Array.new(@nbItemH){|x| Array.new(@nbItemL){|y| Gtk::Image.new()}}
        @vueInventaire = Gtk::Table.new(@nbItemH,@nbItemL,true);
        
        0.upto(@nbItemH-1) do |x|
            0.upto(@nbItemL-1)do |y|
                @inventaire[x][y].file = "coloris_noir.png"
                @vueInventaire.attach(@inventaire[x][y],y,y+1,x,x+1);
            end
        end
        
        window = Gtk::Window.new();
        window.signal_connect('destroy') {
            Gtk.main_quit();
        }
        
        window.add(@vueInventaire)
        window.show_all
        
    end
    
    def afficherInventaire(joueur)
        joueur.inventaire.item.each{|x|
            @inventaire[x%nbItemH][y/nbItemL].file=((@referencesGraphiques.getRefGraphique(x.intitule.downcase)));
        }
    end
end

Gtk.init()
InventaireVue.new
Gtk.main()