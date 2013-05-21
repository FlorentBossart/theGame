#!/usr/bin/env ruby

## 
# Fichier        : InventaireModal.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de crÃ©er la fenÃªtre de l'inventaire
#

require 'gtk2'

# On inclut le module Gtk : cela Ã©vite de prÃ©fixer les classes par 
include Gtk

class InventaireModal
  
   @fenetreInventaire
   @contenu
   @vue #TODO Controler depuis vue
   @nbColonnesMax
   @boutonInteraction
   @tabImages
   @tooltips

  
   #attr_accessor :fenetreInventaire
   #attr_reader :contenu
  
   private_class_method :new

   ##
   # Constructeur privÃ© : la construction se fait par le biais de la mÃ©thode de classe InventaireModal.creer
   #  
   #AFR : on ne tient plus compte du mode d'affichage
   def initialize(vue)
      @vue    = vue
      @nbColonnesMax = 5
      @tabImages     = Array.new()

      #CrÃ©ation de la fenÃªtre d'inventaire
     # @fenetreInventaire = Window.new()
     # @fenetreInventaire.set_default_size(100,100)
     # @fenetreInventaire.set_title("Inventaire")
      
      #Attribution des action liÃ©s aux diffÃ©rents boutons possibles
     # @vue.controller.vendreItem(@@boutonVente)
     # @vue.controller.utiliserItem(@@boutonUtiliser)
     # @vue.controller.acheterItem(@@boutonAcheter)
     # @vue.controller.jeterItem(@@boutonJeter)
     
    @tooltips = Gtk::Tooltips.new
      
   end
  
  
   ##
   # CrÃ©e une nouvelle fenÃªtre d'inventaire Ã  partir des informations passÃ©es en paramÃ¨tre 
   #
   # == ParamÃ¨tres :
   # modeAffichage : le mode d'affichage de l'inventaire (cf EnumStadePartie)
   # controleur    : le controleur liÃ© Ã  l'inventaire
   #
   def InventaireModal.creer(vue)
      return new(vue)
   end
  
  
  
   ##
   # Actualise et affiche la fenÃªtre d'inventaire
   #
   def afficherInventaire(protagoniste, modeAffichage)
      @fenetreInventaire = Window.new()
      @fenetreInventaire.set_default_size(100,100)
      @fenetreInventaire.set_title("Inventaire")
      @vue.window.modal=false

      setModeAffichage(modeAffichage)
      setBoutonInteractionActif(false)
            
      @contenu = VBox.new(false,10)
      
      #Récupération de l'inventaire à afficher      
      if modeAffichage == EnumStadePartie.INTERACTION_MARCHAND_ACHAT
         inventaire = protagoniste.listeItem.itemsStock.clone
         puts "Nb items avt suppression des trop chers = " + protagoniste.listeItem.itemsStock.count.to_s
         #On supprime les items dont le prix est trop cher
         inventaire=inventaire.reject { |item| !@vue.modele.joueur.peutSePermettreAchat?(item) } 
      else
         inventaire = protagoniste.inventaire.items
      end

      #CrÃ©ation du tableau qui contiendra les items
      @tableauItems = Table.new(inventaire.count/@nbColonnesMax, @nbColonnesMax, true) 


      #On parcrous ensuite les items du protagoniste
      indice_ligne   = 0
      indice_colonne = 0

      inventaire.each_with_index do |item, indice| #Pour chaque item...
         #On crÃ©e l'image de l'item
         pixbufItemCourant = Gdk::Pixbuf.new(@vue.referencesGraphiques.getRefGraphique(item.getIntitule.downcase))
         pixbufItemCourant = pixbufItemCourant.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
         imageCourante = Image.new(pixbufItemCourant)

         #On ajoute cette image au tableau d'images
         @tabImages << imageCourante

         #On crÃ©e une EventBox avec l'image de l'item
         eventBoxCourante = EventBox.new.add(imageCourante)
         #eventBoxCourante.set_tooltip_text item.getIntitule + " (" + item.caracteristique.prix.to_s + ")"
         @tooltips.set_tip( eventBoxCourante, item.getIntitule + " (" + item.caracteristique.prix.to_s + ")", nil )

         #On lie l'Ã©vÃ©nement de clic de l'eventBox au Controlleur
         @vue.controller.selectionnerItem(eventBoxCourante,indice)

         #On place l'EventBox dans le tableau destinÃ© Ã  contenir les items
        @tableauItems.attach(eventBoxCourante, indice_colonne, (indice_colonne+1), indice_ligne, (indice_ligne+1) )
         
   #On gÃ¨re les indices de placement
   indice_colonne +=1
         if indice != 0 && (indice+1)%@nbColonnesMax == 0
            indice_ligne  += 1
            indice_colonne = 0
         end 
      end
 
      #La derniÃ¨re image du tableau est utilisÃ©e pour afficher l'image de l'item sÃ©lectionnÃ©
      pixbufItemCourant = Gdk::Pixbuf.new("img/coloris_noir.png") #TODO : placer dans referencesGraphiques
      pixbufItemCourant = pixbufItemCourant.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
      @tabImages << Image.new(pixbufItemCourant) 
    

      @fenetreInventaire.signal_connect('delete_event') {onDestroy} 

      #On ajoute Ã  la vbox les diffÃ©rents Ã©lÃ©ments
      @contenu.pack_start(@tableauItems,true,true,0)
      @contenu.pack_start(@tabImages.last,true,true,0)
      @contenu.pack_start(@boutonInteraction,true,true,0)
      
      #On ajoute la vbox Ã  la fenÃªtre
      @fenetreInventaire.add(@contenu)
      @fenetreInventaire.transient_for=@vue.window
      @fenetreInventaire.modal = true
      @fenetreInventaire.set_window_position Gtk::Window::POS_CENTER
      @fenetreInventaire.show_all
      return @fenetreInventaire
  
   end
  
  
   def setBoutonInteractionActif(isActif)
      @boutonInteraction.set_sensitive(isActif)
   end
  

   ##
   # Fonction invoquÃ©e lorsque la popup de l'inventaire est fermÃ©e
   # Cette fonction permet de faire un clear des Ã©lÃ©ments graphiques et du tableau des images
   # et de masquer la fenÃªtre d'inventaire
   #
   def onDestroy
      puts "Fermeture de l'inventaire !"
      #Supression du tableau d'items (il sera rÃ©gÃ©nÃ©rÃ©)
      #@contenu.remove(@tableauItems)
      #@contenu.remove(@boutonInteraction)
      # @fenetreInventaire.remove(@contenu)
      @fenetreInventaire.modal = false
      #@fenetreInventaire.hide_all
      @tabImages.clear
      @fenetreInventaire.destroy
   end



   ##
   # Fonction modifiant l'image de l'item sÃ©lectionnÃ© par celle de l'item fraichement sÃ©lectionnÃ©
   #
   # == ParamÃ¨tres :
   # indice : l'indice de l'item sÃ©lectionnÃ©
   #
   def setImageSelection(indice)
      pixbufElement = Gdk::Pixbuf.new("img/coloris_noir.png") #TODO : placer dans referencesGraphiques
      pixbufElement = pixbufElement.scale(40,40,Gdk::Pixbuf::INTERP_BILINEAR)
      @tabImages[@tabImages.count-1].pixbuf = @tabImages[indice].pixbuf
      #@tabImages[@tabImages.count-1].file = @tabImages[indice].file
   end



   ##
   # Fonction modifiant le mode d'affichage de l'inventaire pour le rendre adaptable Ã  diffÃ©rentes situations possibles
   # Exemple : situation de rejet d'un item, situation de vente d'un item etc...
   # Le but principal ce cette fonction est donc de modifier le bouton d"interraction en consÃ©quence du mode choisi
   #
   # == ParamÃ¨tres :
   # modeAffichage : le mode d'affichage de l'inventaire (cf EnumStadePartie)
   #
   def setModeAffichage(modeAffichage)
      case modeAffichage
         when EnumStadePartie.INVENTAIRE_PLEIN then
            @boutonInteraction=Button.new(XmlMultilingueReader.lireTexte("boutonJeter"))
            @vue.controller.jeterItem(@boutonInteraction)
            #@vue.controller.jeterItem(@boutonInteraction) #AFR
         #when EnumStadePartie.EQUIPEMENT_ARME then
         #   @boutonInteraction = @@boutonEquiper
         #   @vue.controller.equiperItem(@boutonInteraction) #AFR
         #when EnumStadePartie.EQUIPEMENT_ARMURE then
         #   @boutonInteraction = @@boutonEquiper
         #   @vue.controller.equiperItem(@boutonInteraction) #AFR
         when EnumStadePartie.INTERACTION_MARCHAND_ACHAT then
            @boutonInteraction=Button.new(XmlMultilingueReader.lireTexte("achat"))
            @vue.controller.acheterItem(@boutonInteraction)

            #@vue.controller.acheterItem(@boutonInteraction) #AFR
         when EnumStadePartie.INTERACTION_MARCHAND_VENTE then
            @boutonInteraction=Button.new(XmlMultilingueReader.lireTexte("vendre"))
            @vue.controller.vendreItem(@boutonInteraction)

            #@vue.controller.vendreItem(@boutonInteraction) #AFR
         when EnumStadePartie.INVENTAIRE_USAGE then
            @boutonInteraction=Button.new(XmlMultilingueReader.lireTexte("boutonUtiliser"))
            @vue.controller.utiliserItem(@boutonInteraction)

            #@vue.controller.utiliserItem(@boutonInteraction) #AFR
        end
   end


end #Fin de la classe InventaireModal
