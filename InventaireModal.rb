#!/usr/bin/env ruby

## 
# Fichier        : InventaireModal.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de créer la fenêtre de l'inventaire
#

require 'gtk2'
require 'Bibliotheque/ReferencesGraphiques.rb'

# On inclut le module Gtk : cela évite de préfixer les classes par 
include Gtk

class InventaireModal
	
   @fenetreInventaire
   @contenu
   @controleur #TODO Controler depuis vue
   @referencesGraphiques
   @nbColonnesMax
   @boutonInteraction
   @tabImages

   #Variables de classe/globales
   @@boutonVente   = Button.new("Vendre")
   @@boutonEquiper = Button.new("Equiper")
   @@boutonAcheter = Button.new("Acheter")
   @@boutonJeter   = Button.new("Jeter")
	
   #attr_accessor :fenetreInventaire
   #attr_reader :contenu
	
   private_class_method :new

   ##
   # Constructeur privé : la construction se fait par le biais de la méthode de classe InventaireModal.creer
   #	
   def initialize(modeAffichage, controleur)
      @controleur    = controleur
      @nbColonnesMax = 5
      @tabImages     = Array.new()

      #Création de la fenêtre d'inventaire
      @fenetreInventaire = Window.new()
      @fenetreInventaire.set_default_size(100,100)
      @fenetreInventaire.set_title("Inventaire")

      #Initialisation des références graphiques
      #TODO : récupérer les référence depuis la vue
      @referencesGraphiques = ReferencesGraphiques.new()
      XmlRefGraphiquesReader.lireXml(@referencesGraphiques)

      setModeAffichage(modeAffichage)
   end
	
	
   ##
   # Crée une nouvelle fenêtre d'inventaire à partir des informations passées en paramètre 
   #
   # == Paramètres :
   # modeAffichage : le mode d'affichage de l'inventaire (cf EnumStadePartie)
   # controleur    : le controleur lié à l'inventaire
   #
   def InventaireModal.creer(modeAffichage, controleur)
      return new(modeAffichage, controleur)
   end
	
	
	
   ##
   # Actualise et affiche la fenêtre d'inventaire
   #
   def afficherInventaire(joueur)

      @contenu = VBox.new(false,10)

      #Création du tableau qui contiendra les items
      @tableauItems = Table.new(joueur.inventaire.items.count/@nbColonnesMax, @nbColonnesMax, true) 


      #On parcrous ensuite les items du joueur
      indice_ligne   = 0
      indice_colonne = 0

      joueur.inventaire.items.each_with_index do |item, indice| #Pour chaque item...
         #On crée l'image de l'item
         pixbufItemCourant = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(item.getIntitule.downcase))
         pixbufItemCourant = pixbufItemCourant.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
         imageCourante = Image.new(pixbufItemCourant)

	 #On ajoute cette image au tableau d'images
         @tabImages << imageCourante

         #On crée une EventBox avec l'image de l'item
	 eventBoxCourante = EventBox.new.add(imageCourante)

         #On lie l'événement de clic de l'eventBox au Controlleur
         @controleur.selectionnerItem(eventBoxCourante,indice)

         #On place l'EventBox dans le tableau destiné à contenir les items
 	 @tableauItems.attach(eventBoxCourante, indice_colonne, (indice_colonne+1), indice_ligne, (indice_ligne+1) )
         
	 #On gère les indices de placement
	 indice_colonne +=1
         if indice != 0 && (indice+1)%@nbColonnesMax == 0
            indice_ligne  += 1
            indice_colonne = 0
         end 
      end
 
      #La dernière image du tableau est utilisée pour afficher l'image de l'item sélectionné
      pixbufItemCourant = Gdk::Pixbuf.new("img/coloris_noir.png") #TODO : placer dans referencesGraphiques
      pixbufItemCourant = pixbufItemCourant.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
      @tabImages << Image.new(pixbufItemCourant) 
		

      @fenetreInventaire.signal_connect('delete_event') {onDestroy}	

      #On ajoute à la vbox les différents éléments
      @contenu.pack_start(@tableauItems,true,true,0)
      @contenu.pack_start(@tabImages.last,true,true,0)
      @contenu.pack_start(@boutonInteraction,true,true,0)
      
      #On ajoute la vbox à la fenêtre
      @fenetreInventaire.add(@contenu)

      @fenetreInventaire.show_all
      return @fenetreInventaire
	
   end
	
	

   ##
   # Fonction invoquée lorsque la popup de l'inventaire est fermée
   # Cette fonction permet de faire un clear des éléments graphiques et du tableau des images
   # et de masquer la fenêtre d'inventaire
   #
   def onDestroy
      puts "Fermeture de l'inventaire !"
      #Supression du tableau d'items (il sera régénéré)
      @contenu.remove(@tableauItems)
      @contenu.remove(@boutonInteraction)
      @fenetreInventaire.remove(@contenu)
      @fenetreInventaire.hide_all
      @tabImages.clear
   end



   ##
   # Fonction modifiant l'image de l'item sélectionné par celle de l'item fraichement sélectionné
   #
   # == Paramètres :
   # indice : l'indice de l'item sélectionné
   #
   def setImageSelection(indice)
      pixbufElement = Gdk::Pixbuf.new("img/coloris_noir.png") #TODO : placer dans referencesGraphiques
      pixbufElement = pixbufElement.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
      @tabImages[@tabImages.count-1].pixbuf = @tabImages[indice].pixbuf
      #@tabImages[@tabImages.count-1].file = @tabImages[indice].file
   end



   ##
   # Fonction modifiant le mode d'affichage de l'inventaire pour le rendre adaptable à différentes situations possibles
   # Exemple : situation de rejet d'un item, situation de vente d'un item etc...
   # Le but principal ce cette fonction est donc de modifier le bouton d"interraction en conséquence du mode choisi
   #
   # == Paramètres :
   # modeAffichage : le mode d'affichage de l'inventaire (cf EnumStadePartie)
   #
   def setModeAffichage(modeAffichage)
      case modeAffichage
         when EnumStadePartie.INVENTAIRE_PLEIN then
            @boutonInteraction = @@boutonJeter
            @controleur.jeterItem(@boutonInteraction) #AFR
         when EnumStadePartie.EQUIPEMENT_ARME then
            @boutonInteraction = @@boutonEquiper
            @controleur.equiperItem(@boutonInteraction) #AFR
         when EnumStadePartie.EQUIPEMENT_ARMURE then
            @boutonInteraction = @@boutonEquiper
            @controleur.equiperItem(@boutonInteraction) #AFR
         when EnumStadePartie.INTERACTION_MARCHAND_ACHAT then
            @boutonInteraction = @@boutonAcheter
            @controleur.acheterItem(@boutonInteraction) #AFR
         when EnumStadePartie.INTERACTION_MARCHAND_VENTE then
            @boutonInteraction = @@boutonVente
            @controleur.vendreItem(@boutonInteraction) #AFR
        end
   end


end #Fin de la classe InventaireModal

