require 'gtk2'
require 'Bibliotheque/ReferencesGraphiques.rb'
require 'Enum/EnumStadePartie.rb'

#AFR
require 'Modele.rb'
require 'Vue.rb'
require 'Controller.rb'

class InventaireVue
    #Variables d'instance
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
    
    #Variables de classe/globales
    @@boutonVente = Gtk::Button.new("Vendre")
    @@boutonEquiper = Gtk::Button.new("Equiper")
    @@boutonAcheter = Gtk::Button.new("Acheter")
    @@boutonJeter = Gtk::Button.new("Jeter")
    
    
    
#AFR    
@@vue=Vue.new()
@@modele=Modele.creer(@@vue,'T',"Lecarpla")
@@controller=Controller.creer(@@modele,@@vue)

    
    attr_reader :vbox
    
    private_class_method :new
    
    def InventaireVue.creer(mode)
        return new(mode)
    end
    
    def initialize(mode)
        @nbItemH = 5
        @nbItemL = 5
        @inventaire = Array.new(@nbItemH){|x| Array.new(@nbItemL){|y| Gtk::Image.new()}}
        @eventInventaire = Array.new(@nbItemH){|x| Array.new(@nbItemL){|y| Gtk::EventBox.new()}}
        
        @imageItemSelected = Gtk::Image.new("img/coloris_noir.png")
        @vbox = Gtk::VBox.new(false,10)
        @hbox = Gtk::HBox.new(false,10)
        @vueInventaire = Gtk::Table.new(@nbItemH,@nbItemL,true);
        
        case mode
            when EnumStadePartie.INVENTAIRE_PLEIN then
            @boutonInteraction = @@boutonJeter
            when EnumStadePartie.EQUIPEMENT_ARME then
            @boutonInteraction = @@boutonEquiper
            when EnumStadePartie.EQUIPEMENT_ARMURE then
            @boutonInteraction = @@boutonEquiper
            when EnumStadePartie.INTERACTION_MARCHAND_ACHAT then
            @boutonInteraction = @@boutonAcheter
            when EnumStadePartie.INTERACTION_MARCHAND_VENTE then
            @boutonInteraction = @@boutonVente
        end
        0.upto(@nbItemH-1) do |x|
            0.upto(@nbItemL-1)do |y|
                @inventaire[x][y].file = "img/test/"+(x*@nbItemL+y).to_s+".png"
                @eventInventaire[x][y].add(@inventaire[x][y])
                #(@eventInventaire[x][y])
                @vueInventaire.attach(@eventInventaire[x][y],y,y+1,x,x+1);
                                
                #AFR
                @@controller.selectionnerItem(@eventInventaire[x][y],x*@nbItemL+y)
      
            end
        end
        @vbox.pack_start(@vueInventaire,true,true,0)
        @vbox.pack_start(@hbox,true,true,0)
        @hbox.pack_start(@imageItemSelected,true,true,0)
        @hbox.pack_start(@boutonInteraction,true,true,0)
        return self
    end
    
    def setImageSelection(image)
        @imageItemSelected.file=image
    end
    
    def obtenirVueInventaire(joueur)
        joueur.inventaire.item.each{|x|
           @inventaire[x%nbItemH][y/nbItemL].file=((@referencesGraphiques.getRefGraphique(x.intitule.downcase)));
        }
	return @vbox
    end

    def InventaireVue.afficherInventaire(joueur, mode)
        window = Gtk::Window.new();
        window.signal_connect('destroy') {
           Gtk.main_quit();
        }
        iv = InventaireVue.creer(mode)
        #iv.obtenirVueInventaire(nil)
        window.add(iv.vbox)
        window.show_all
    end
    
end

Gtk.init()
InventaireVue.afficherInventaire(nil,EnumStadePartie.INTERACTION_MARCHAND_VENTE)
Gtk.main()
