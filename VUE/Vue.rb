#COMPAR
#!/usr/bin/env ruby

##
# Fichier         : Vue.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
# Cette classe est responsable de l'affichage du jeu dan sa totalité et regroupe différents sous-éléments graphiques.
#

require 'gtk2'
require 'VUE/Zaf.rb'
require 'VUE/MenuJeu.rb'
require 'VUE/ZoneCtrl.rb'
require 'VUE/ReferencesGraphiques.rb'
require 'VUE/InteractionModal.rb'
require 'VUE/CombatModal.rb'
require 'VUE/PopUp.rb'
require 'VUE/InventaireModal.rb'
require 'MODELE/Enum/EnumDirection.rb'
require 'MODELE/Carte.rb'
require 'XMLReader/XmlRefGraphiquesReader.rb'

class Vue

  #éléments graphiques
  @zaf
  @menu
  @zoneCtrl
  @background
  @frame
  @carteVue
  @combatModal
  @interactionModal
  @popUp
  @window
  @inventaireModal
  
  #composants externes
  @carte
  @referencesGraphiques  #fichier xml des images
  @modele
  @controller
  
  #données de la vue
  @tailleCase
  @tailleCase_f
  @delay  # vitesse des animations
  @numEtapeAffichage #  numero de l'etape d'affichage des visualisations
  @nbEtapeAffichage # nombre d'éape d'affichage des visualisations
  @timeout_id # la référence de l'animation en cours
  @positions  # les différentes positions occupable dans une case
  @structureEnnemisDeplacement #  les ennemis à animer
  @structureAidesGenere#  les aides à animer
  @hauteurAfficheCarte #  hauteurVisible
  @largeurAfficheCarte #  largeurVisible
  @x #  coordonnée x actuel du coin supérieur gauche
  @y #  coordonnée y actuel du coin supérieur gauche
  @finInit# état d'initialisation de la vue
  @transitionFini# état d'activité d'une animation
  
  #touches ecoutees
  @ecouteUp
  @ecouteDown
  @ecouteLeft
  @ecouteRight
  @ecouteToucheRepos
  @ecouteToucheInventaire
  @ecouteToucheMenu
  @ecouteToucheInteraction

  attr_reader :referencesGraphiques, :modele, :hauteurAfficheCarte, :largeurAfficheCarte, :ecouteUp, :ecouteDown, :ecouteLeft, :ecouteRight, :ecouteToucheRepos, :ecouteToucheInventaire, :ecouteToucheMenu, :ecouteToucheInteraction, :inventaireModal, :transitionFini
  attr_accessor :x , :y, :menu, :interactionModal, :popUp, :combatModal, :controller, :zoneCtrl, :window
  
  private_class_method :new
  
  ##
  #Permet de créer une nouvelle vue
  #
  def Vue.creer()
    new()
  end

  ##
  #Permet de définir le modèle de la vue
  #
  #===Paramètres :
  #* <b>modele</b> : Le modèle
  #
  def defM(modele)
    @modele = modele
  end

  ##
  #Permet de définir le contrôleur de la vue
  #
  #===Paramètres :
  #* <b>controller</b> : Le contrôleur
  #
  def defC(controller)
    @controller=controller
  end

  ##
  #Initialise la vue
  #
  def initInterface()
    Gtk.init()

    @finInit = false
    
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)
    
    @tailleCase=130
    @tailleCase_f=@tailleCase.to_f
    @hauteurAfficheCarte = 4
    @largeurAfficheCarte = 10
    @timeout_id=nil
    @delay=20
    @numEtapeAffichage=0
    @nbEtapeAffichage=40
    @positions=Array.new([[@tailleCase_f/3,@tailleCase_f/3],[@tailleCase_f/3,0.1],[0.1,@tailleCase_f/3],
      [2*@tailleCase_f/3,@tailleCase_f/3],[@tailleCase_f/3,2*@tailleCase_f/3],[0.1,0.1]])
    @structureEnnemisDeplacement  = Array.new()
    @structureAidesGenere = Array.new()
    @x=@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2
    @y=@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2
    @carte = @modele.carte
    
    @inventaireModal=InventaireModal.creer(self)
    @zaf = Zaf.new(self)
    @menu = MenuJeu.creer(true, @modele, @controller)
    @zoneCtrl = ZoneCtrl.creer(self,@controller)
    @popUp=PopUp.creer(self)
    @interactionModal=InteractionModal.creer(@modele,self)
    @combatModal=CombatModal.creer(self,@modele)
    @window = Gtk::Window.new()
    
    @window.signal_connect('destroy') {
      if(@timeout_id!=nil)
        Gtk.timeout_remove(@timeout_id)
      end
      Gtk.main_quit()
    }
    
    @background = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("blanc"))
    @background=@background.scale(@tailleCase*@largeurAfficheCarte, @tailleCase*@hauteurAfficheCarte,Gdk::Pixbuf::INTERP_BILINEAR)
    @frame = Gdk::Pixbuf.new(Gdk::Pixbuf::COLORSPACE_RGB,false, 8,@background.width, @background.height)
    @carteVue = Gtk::DrawingArea.new
    @carteVue.set_size_request(@background.width, @background.height)
   
    @carteVue.signal_connect('expose_event') do |w, e|
      expose(w, e)
    end
    
    

    bloquerEcouteClavier()
    @controller.ecouteClavierCreer(@window)
    
    tabBot = Gtk::Table.new(1,3,true)
    tabBot.attach(@zaf,0,2,0,1)
    tabBot.attach(@zoneCtrl,2,3,0,1)
    vbox = Gtk::VBox.new()
    vbox.add(@carteVue)
    valignBot = Alignment.new(0.5,1,1,0)
    valignBot.add(tabBot)
    vbox.add(valignBot)

    window.set_resizable(false)
    @window.add(vbox)
    @window.set_title("THE GAME")
    @window.show_all()

    Thread.new do @modele.debutTour() end #lancé ici : à déplacer dans bouton debut partie
    
    @finInit = true;
    Gtk.main();
  end

  ##
  #Dessine dans la vue de la carte l'état actuel du jeu dans cette zone
  #
  def afficheCarte()
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carte.getCaseAt(x+@x,y+@y).verifEnnemis 
        afficheCase(y*@tailleCase,x*@tailleCase,@carte.getCaseAt(x+@x,y+@y),true,@background) # nos axe x et y sont inversés par rapport à ceux de gtk/gdk
      end
    end
    @carteVue.window.draw_pixbuf(nil, @background, 0, 0, 0, 0, @background.width, @background.height, Gdk::RGB::DITHER_NORMAL, 0, 0)
  end

  ##
  #Entraine une animation des déplacments/création des PNJ
  #
  def afficheCarteDyn()
    @structureEnnemisDeplacement.clear()
    @structureAidesGenere.clear()

    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carte.getCaseAt(x+@x,y+@y).verifEnnemis 
        afficheCaseDyn(y*@tailleCase,x*@tailleCase,@carte.getCaseAt(x+@x,y+@y))
      end
    end

    if(@timeout_id==nil)
      bloquerEcouteClavier()
      @zoneCtrl.bloquerBoutons(@modele)
      @timeout_id = Gtk.timeout_add(@delay) do
        timeout()
      end
    end
  end

  ##
  #Entraine une animation pour le déplacement du joueur
  #
  def afficheCarteMvt()
    if(@modele.joueur.direction==EnumDirection.NORD||@modele.joueur.direction==EnumDirection.SUD)
      h=1
      l=0
    elsif(@modele.joueur.direction==EnumDirection.EST||@modele.joueur.direction==EnumDirection.OUEST)
      h=0
      l=1
    end
    if(@modele.joueur.direction==EnumDirection.SUD)
      hDec=-1
      lDec=0
    elsif(@modele.joueur.direction==EnumDirection.EST)
      hDec=0
      lDec=-1
    else
      hDec=0
      lDec=0
    end

    @pixFond=pixbufTerrain = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("blanc"))
    @pixFond=@pixFond.scale(@tailleCase*(@largeurAfficheCarte+l), @tailleCase*(@hauteurAfficheCarte+h),Gdk::Pixbuf::INTERP_BILINEAR)
    0.upto(@hauteurAfficheCarte-1+h) do |x|
      0.upto(@largeurAfficheCarte-1+l)do |y|
        afficheCase(y*@tailleCase,x*@tailleCase,@carte.getCaseAt(x+@x+hDec,y+@y+lDec),false,@pixFond)
      end
    end

    case @modele.joueur.direction
    when EnumDirection.NORD
      pixbufJoueur = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"N"))
      pixbufJoueurb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"Nb"))
    when EnumDirection.SUD
      pixbufJoueur = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"S"))
      pixbufJoueurb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"Sb"))
    when EnumDirection.EST
      pixbufJoueur = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"E"))
      pixbufJoueurb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"Eb"))
    when EnumDirection.OUEST
      pixbufJoueur = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"O"))
      pixbufJoueurb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.joueur.getIntitule().downcase+"Ob"))
    end
    pixbufJoueur=pixbufJoueur.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
    pixbufJoueurb=pixbufJoueurb.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)

    if(@timeout_id==nil)
      bloquerEcouteClavier()
      @zoneCtrl.bloquerBoutons(@modele)
      @timeout_id = Gtk.timeout_add(@delay) do
        timeoutMvt(pixbufJoueur,pixbufJoueurb)
      end
    else
      raise "actualisation pas synchro"
    end
  end

  def getNumTerrain(intitule)
    if(intitule=="montagne")
      return 4
    elsif(intitule=="eau")
      return 3
    elsif(intitule=="desert")
      return 2
    else
      return 1
    end
  end

  def afficheCase(xAff,yAff,caseAffiche,afficherJoueur,pixbufBase)

    #terrain
    pixbufTerrain = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.getIntitule().downcase))
    pixbufTerrain=pixbufTerrain.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)

    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)).to_s()+"1"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)).to_s()+"2"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)).to_s()+"3"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)).to_s()+"4"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    pixbufBase.composite!(pixbufTerrain, xAff,yAff, pixbufTerrain.width, pixbufTerrain.height,xAff, yAff,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)

    #joueur
    if(caseAffiche.joueur!=nil && afficherJoueur)
      if(caseAffiche.joueur.toujoursEnVie?())
        case caseAffiche.joueur.direction
        when EnumDirection.NORD
          pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"N"))
        when EnumDirection.SUD
          pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"S"))
        when EnumDirection.EST
          pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"E"))
        when EnumDirection.OUEST
          pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"O"))
        end
      else
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("tombe"))
      end
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      rg=caseAffiche.joueur.rangCase
      x=@positions[rg][0]
      y=@positions[rg][1]
      pixbufBase.composite!(pixbufElement, xAff+x,yAff+y, pixbufElement.width, pixbufElement.height,xAff+x, yAff+y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    #aides
    aides=caseAffiche.listeElements
    for a in aides
      rg=a.rangCase
      x=@positions[rg][0]
      y=@positions[rg][1]
      pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(a.getIntitule().downcase))
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufBase.composite!(pixbufElement, xAff+x,yAff+y, pixbufElement.width, pixbufElement.height,xAff+x, yAff+y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    #ennemis
    ennemis=caseAffiche.listeEnnemis
    for e in ennemis

      case e.direction
      when EnumDirection.NORD
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"N"))
      when EnumDirection.SUD
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"S"))
      when EnumDirection.EST
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"E"))
      when EnumDirection.OUEST
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"O"))
      end
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)

      rg=e.rangCase
      xPos=@positions[rg][0]
      yPos=@positions[rg][1]

      xArr=xAff+xPos
      yArr=yAff+yPos

      pixbufBase.composite!(pixbufElement, xArr,yArr, pixbufElement.width, pixbufElement.height,xArr,yArr,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    return nil
  end

  def afficheCaseDyn(xAff,yAff,caseAffiche)

    #terrain
    pixbufTerrain = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.getIntitule().downcase))
    pixbufTerrain=pixbufTerrain.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)

    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)).to_s()+"1"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)).to_s()+"2"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)).to_s()+"3"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)).to_s()+"4"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(@tailleCase, @tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    @background.composite!(pixbufTerrain, xAff,yAff, pixbufTerrain.width, pixbufTerrain.height,xAff, yAff,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)

    #joueur
    if(caseAffiche.joueur!=nil)
      if(caseAffiche.joueur.toujoursEnVie?())
        if(caseAffiche.joueur.enRepos)
          pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("dormeur"))
        else
          case caseAffiche.joueur.direction
          when EnumDirection.NORD
            pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"N"))
          when EnumDirection.SUD
            pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"S"))
          when EnumDirection.EST
            pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"E"))
          when EnumDirection.OUEST
            pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase+"O"))
          end
        end
      else
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("tombe"))
      end
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      rg=caseAffiche.joueur.rangCase
      x=@positions[rg][0]
      y=@positions[rg][1]
      @background.composite!(pixbufElement, xAff+x,yAff+y, pixbufElement.width, pixbufElement.height,xAff+x, yAff+y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    #aides
    aides=caseAffiche.listeElements
    for a in aides
      rg=a.rangCase
      x=@positions[rg][0]
      y=@positions[rg][1]
      pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(a.getIntitule().downcase))
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      if(!a.vientDEtreGenere?())
        @background.composite!(pixbufElement, xAff+x,yAff+y, pixbufElement.width, pixbufElement.height,xAff+x, yAff+y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
      else
        @structureAidesGenere.push([xAff+x,yAff+y,pixbufElement])
      end
    end

    #ennemis
    ennemis=caseAffiche.listeEnnemis
    for e in ennemis

      case e.direction
      when EnumDirection.NORD
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"N"))
        pixbufElementb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"Nb"))
      when EnumDirection.SUD
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"S"))
        pixbufElementb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"Sb"))
      when EnumDirection.EST
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"E"))
        pixbufElementb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"Eb"))
      when EnumDirection.OUEST
        pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"O"))
        pixbufElementb = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"Ob"))
      end
      pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufElementb=pixbufElementb.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)

      rg=e.rangCase
      #puts "rg = " + rg.to_s
      xPos=@positions[rg][0]
      #puts "xPos = " + xPos.to_s
      yPos=@positions[rg][1]
      #puts "yPos = " + yPos.to_s

      #COORD SUR CARTE -> INVERSEES PAR / AU PIXBUF
      xAncien=e.anciennePositionX
      yAncien=e.anciennePositionY

      xArr=xAff
      yArr=yAff

      # Rajout� par ludo
      #xDep = 0
      #yDep = 0

      if(e.vientDEtreGenere?())
        if(!(xAncien==-1 && yAncien==-1))
          raise "err1"
        end
        traitement="zoom"
        xArr=xArr+xPos
        yArr=yArr+yPos
        @structureEnnemisDeplacement.push([traitement,nil,nil,xArr,yArr,pixbufElement,nil])
      else
        ancienneCase=@modele.carte().getCaseAt(xAncien,yAncien)

        #puts e.getIntitule+" "+xAncien.to_s+" "+yAncien.to_s()
        #puts e.getIntitule+" "+e.casePosition.coordonneeX.to_s+" "+e.casePosition.coordonneeY.to_s
        if(ancienneCase==e.casePosition)
          #puts "ici "+e.getIntitule()
          @background.composite!(pixbufElement, xAff+xPos,yAff+yPos, pixbufElement.width, pixbufElement.height,xAff+xPos, yAff+yPos,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
        else
          #puts "la "+e.getIntitule()
          traitement="depl"
          rgAncien=e.ancienRangCase
          xPosAncien=@positions[rgAncien][0]
          yPosAncien=@positions[rgAncien][1]

          if(ancienneCase==e.casePosition.caseNord())
            xDep=xArr
            yDep=yArr-@tailleCase
          elsif(ancienneCase==e.casePosition.caseSud())
            xDep=xArr
            yDep=yArr+@tailleCase
          elsif(ancienneCase==e.casePosition.caseEst())
            xDep=xArr+@tailleCase
            yDep=yArr
          elsif(ancienneCase==e.casePosition.caseOuest())
            xDep=xArr-@tailleCase
            yDep=yArr
          end

          if(xDep==nil)
            puts e.getIntitule+" "+xAncien.to_s+" "+yAncien.to_s()
            puts e.getIntitule+" "+e.casePosition.coordonneeX.to_s+" "+e.casePosition.coordonneeY.to_s
            raise "err2"
          end

          if(xDep<0)
            xDep=0
          end
          if(xDep>(@largeurAfficheCarte-1)*@tailleCase)
            xDep=(@largeurAfficheCarte-1)*@tailleCase
          end
          if(yDep<0)
            yDep=0
          end
          if(yDep>(@hauteurAfficheCarte-1)*@tailleCase)
            yDep=(@hauteurAfficheCarte-1)*@tailleCase
          end
          xDep=xDep+xPosAncien
          yDep=yDep+yPosAncien
        end
        xArr=xArr+xPos
        yArr=yArr+yPos

        @structureEnnemisDeplacement.push([traitement,xDep,yDep,xArr,yArr,pixbufElement,pixbufElementb])
        #puts "XDEP"+xDep.to_s
        #puts "YDEP"+yDep.to_s
        #puts "XARR"+xArr.to_s
        #puts "YARR"+yArr.to_s
      end
    end
    return nil
  end

  def getZaf()
    return @zaf
  end

  def actualiser
    # @window.modal=true

    puts "\tdebut actualiser"

    #if(@@threadAffichage == false)
    # @@threadAffichage = true
    # @modele.enverDuDecors
    #Thread.new do
    # while(true) do
    #maj Carte Et Zaf
    @x=@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2
    @y=@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2
    #COORD DU COIN GAUCHE SUP DE LA VUE

    if(@modele.stadePartie==EnumStadePartie.TOUR_PASSE || @modele.compteurTour==0)
      @transitionFini=false
      afficheCarteDyn()
      while(!@transitionFini) do
        #puts "jepassela"
        sleep(0.1)
      end
    elsif(@modele.stadePartie==EnumStadePartie.JOUEUR_MVT)
      @transitionFini=false
      afficheCarteMvt()
      # while(!@transitionFini) do
      #puts "jepassela"
      # sleep(0.1)
      # end
      sleep(1)
    else
      afficheCarte()
    end

    #afficheCarte()
    @zaf.majZaf(@modele.joueur)
    #sleep(0.01)
    # end
    #end
    #end
    case @modele.stadePartie

    #ETAPE CHOIX LIBRE
    when EnumStadePartie.CHOIX_LIBRE
      #@zoneCtrl.majBoutons(@modele)
      #majEcouteClavier()
      #ETAPE PARTIE PERDUE
    when EnumStadePartie.PERDU
      @zoneCtrl.bloquerBoutons(@modele)
      bloquerEcouteClavier()
      #ETAPE EQUIPEMENT ARMURE
    when EnumStadePartie.EQUIPEMENT_ARMURE
      @combatModal.majEquipementDefensif()
      #ETAPE EQUIPEMENT ARME
    when EnumStadePartie.EQUIPEMENT_ARME
      @combatModal.majEquipementOffensif()
      #ETAPE INVENTAIRE PLEIN
    when EnumStadePartie.INVENTAIRE_PLEIN

      #ETAPE INTERACTION MARCHAND
    when EnumStadePartie.INTERACTION_MARCHAND
      @popUp.afficheChoixMarchand()
      #ETAPE INTERACTION MARCHAND ACHAT
    when EnumStadePartie.INTERACTION_MARCHAND_ACHAT

      #ETAPE INTERACTION MARCHAND VENTE
    when EnumStadePartie.INTERACTION_MARCHAND_VENTE

      #ETAPE INTERACTOIN GUERISSEUR
    when EnumStadePartie.INTERACTION_GUERISSEUR
      @popUp.afficheChoixGuerisseur(@modele.joueur, @modele.pnjAideEnInteraction)
    end #fin case

    puts "\tfin actualiser"
  end

  def majEcouteClavier()
    @ecouteUp=@modele.joueur.casePosition.caseNord.estAccessible?()
    @ecouteDown=@modele.joueur.casePosition.caseSud.estAccessible?()
    @ecouteLeft=@modele.joueur.casePosition.caseOuest.estAccessible?()
    @ecouteRight=@modele.joueur.casePosition.caseEst.estAccessible?()
    @ecouteToucheRepos=@modele.joueur.nombreRepos!=0
    @ecouteToucheInventaire=!@modele.joueur.inventaire.items.empty?()
    @ecouteToucheMenu=true
    @ecouteToucheInteraction=@modele.joueur.casePosition.presenceAides?()
  end

  def bloquerEcouteClavier()
    @ecouteUp=false
    @ecouteDown=false
    @ecouteLeft=false
    @ecouteRight=false
    @ecouteToucheRepos=false
    @ecouteToucheInventaire=false
    #@ecouteToucheMenu=false
    @ecouteToucheInteraction=false
  end

  #mise a jour de la langue
  def majLangue()
    @zaf.majLangue();
    @zoneCtrl.majLangue();
  end

  def expose(widget, event)
    rowstride = @frame.rowstride

    pixels = @frame.pixels
    pixels[0, rowstride * event.area.y + event.area.x * 3] = ''

    Gdk::RGB.draw_rgb_image(widget.window,
    widget.style.black_gc,
    event.area.x, event.area.y,
    event.area.width, event.area.height,
    Gdk::RGB::Dither::NORMAL,
    pixels, rowstride,
    event.area.x, event.area.y)
    true
  end

  # Timeout handler to regenerate the frame
  def timeout()
    @background.copy_area(0, 0, @background.width, @background.height,
    @frame, 0, 0)
    @numEtapeAffichage+=1

    for a in @structureAidesGenere
      xArr=a[0]
      yArr=a[1]
      pixbuf=a[2]
      w= (pixbuf.width*(@numEtapeAffichage.to_f()/@nbEtapeAffichage)).to_i
      h= (pixbuf.height*(@numEtapeAffichage.to_f()/@nbEtapeAffichage)).to_i
      if w==0
        w=1
      end
      if h==0
        h=1
      end
      zoomPix=pixbuf.scale(w,h,Gdk::Pixbuf::INTERP_BILINEAR)
      @frame.composite!(zoomPix,xArr,yArr,zoomPix.width, zoomPix.height,xArr,yArr,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    for e in @structureEnnemisDeplacement
      traitement=e[0]
      xDep=e[1]
      yDep=e[2]
      xArr=e[3]
      yArr=e[4]
      pixbuf=e[5]
      pixbufb=e[6]

      if(traitement=="zoom")
        w= (pixbuf.width*(@numEtapeAffichage.to_f()/@nbEtapeAffichage)).to_i
        h= (pixbuf.height*(@numEtapeAffichage.to_f()/@nbEtapeAffichage)).to_i
        if w==0
          w=1
        end
        if h==0
          h=1
        end
        zoomPix=pixbuf.scale(w,h,Gdk::Pixbuf::INTERP_BILINEAR)
        @frame.composite!(zoomPix,xArr,yArr,zoomPix.width, zoomPix.height,xArr,yArr,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
      elsif(traitement=="depl")
        if(
        (   @numEtapeAffichage<=@nbEtapeAffichage*(1.0/6) )  ||
        (   @numEtapeAffichage> @nbEtapeAffichage*(1.0/3) && @numEtapeAffichage<=@nbEtapeAffichage*0.5  )   ||
        (   @numEtapeAffichage> @nbEtapeAffichage*(2.0/3) && @numEtapeAffichage<=@nbEtapeAffichage*(5.0/6)   )
          )
          pixbufActuel=pixbuf
        else
          pixbufActuel=pixbufb
        end

        x=xDep+@numEtapeAffichage*(xArr-xDep)/@nbEtapeAffichage
        y=yDep+@numEtapeAffichage*(yArr-yDep)/@nbEtapeAffichage
        @frame.composite!(pixbufActuel,x,y,pixbufActuel.width, pixbufActuel.height,x, y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
      end
    end

    @carteVue.queue_draw
    if(@numEtapeAffichage==@nbEtapeAffichage)
      Gtk.timeout_remove(@timeout_id)
      @numEtapeAffichage=0
      @timeout_id=nil
      majEcouteClavier()
      @zoneCtrl.majBoutons(@modele)
      @transitionFini=true
    end
    true
  end

  # Timeout handler to regenerate the frame
  def timeoutMvt(pix,pixb)
    @background.copy_area(0, 0, @background.width, @background.height,
    @frame, 0, 0)
    @numEtapeAffichage+=1

    case @modele.joueur.direction
    when EnumDirection.NORD
      parcours=@pixFond.height-@background.height
      ecartH=-((@nbEtapeAffichage-@numEtapeAffichage)*((parcours).to_f)/@nbEtapeAffichage).to_i
      x=0
      y=ecartH
      #puts ecartH
    when EnumDirection.SUD
      parcours=@pixFond.height-@background.height
      ecartH=((@nbEtapeAffichage-@numEtapeAffichage)*((parcours).to_f)/@nbEtapeAffichage).to_i - @tailleCase
      x=0
      y=ecartH
      #puts ecartH
    when EnumDirection.EST
      parcours=@pixFond.width-@background.width
      ecartL=((@nbEtapeAffichage-@numEtapeAffichage)*((parcours).to_f)/@nbEtapeAffichage).to_i - @tailleCase
      x=ecartL
      y=0
      #puts ecartL
    when EnumDirection.OUEST
      parcours=@pixFond.width-@background.width
      ecartL=-((@nbEtapeAffichage-@numEtapeAffichage)*((parcours).to_f)/@nbEtapeAffichage).to_i
      x=ecartL
      y=0
      #puts ecartL
    end

    if(
    (   @numEtapeAffichage<=@nbEtapeAffichage*(1.0/6) )  ||
    (   @numEtapeAffichage> @nbEtapeAffichage*(1.0/3) && @numEtapeAffichage<=@nbEtapeAffichage*0.5  )   ||
    (   @numEtapeAffichage> @nbEtapeAffichage*(2.0/3) && @numEtapeAffichage<=@nbEtapeAffichage*(5.0/6)   )
      )
      pixActuel=pix
    else
      pixActuel=pixb
    end

    xJ=@tailleCase*@largeurAfficheCarte/2+@positions[0][0]
    yJ=@tailleCase*@hauteurAfficheCarte/2+@positions[0][1]
    @frame.composite!(@pixFond,0,0,@background.width, @background.height,x, y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    @frame.composite!(pixActuel,xJ, yJ,pixActuel.width, pixActuel.height,xJ, yJ,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)

    @carteVue.queue_draw
    if(@numEtapeAffichage==@nbEtapeAffichage)
      Gtk.timeout_remove(@timeout_id)
      @numEtapeAffichage=0
      @timeout_id=nil
      majEcouteClavier()
      @zoneCtrl.majBoutons(@modele)
      @transitionFini=true
    end
    true
  end

end

