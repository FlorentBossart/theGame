#!/usr/bin/env ruby

##
# Fichier            : Vue.rb
# Auteur            : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente l'affichage du jeu dan sa totalité
#
require 'gtk2'
require './Zaf.rb'
require './MenuJeu.rb'
require './ZoneCtrl.rb'
require './Carte.rb'
require './Bibliotheque/ReferencesGraphiques.rb'
require './XMLReader/XmlRefGraphiquesReader.rb'
require './InteractionModal.rb'
require './CombatModal.rb'
require './PopUp.rb'
require './InventaireModal.rb'
require './Enum/EnumDirection.rb'

class Vue

  @vue #affichage carte
  @zaf
  @menu
  @zoneCtrl
  @carte #la classe carte
  @referencesGraphiques #fichier xml des images
  
  @tailleCase
  @tailleCase_f
  
  @delay
  @numEtapeAffichage
  @nbEtapeAffichage
  @background
  @frame
  @carteVue
  @timeout_id
  @positions
  @structureEnnemisDeplacement
  @structureAidesGenere
  
  @hauteurAfficheCarte #hauteurVisible
  @largeurAfficheCarte #largeurVisible
  @modele
  @controller
  @x #coordonné actuel
  @y #coordonné actuel
  @combatModal
  @interactionModal
  @popUp
  @window
  @tailleCase #taille d'une case
  @finInit

  #touches ecoutees
  @ecouteUp
  @ecouteDown
  @ecouteLeft
  @ecouteRight
  @ecouteToucheRepos
  @ecouteToucheInventaire
  @ecouteToucheMenu
  @ecouteToucheInteraction
  
  @inventaireModal
  
  @initialisee
  
  @@threadAffichage = false 
  
  
  attr_reader :modele, :hauteurAfficheCarte, :largeurAfficheCarte, :ecouteUp, :ecouteDown, :ecouteLeft, :ecouteRight, :ecouteToucheRepos, :ecouteToucheInventaire, :ecouteToucheMenu, :ecouteToucheInteraction, :inventaireModal, :initialisee
  attr_accessor :x , :y, :menu, :interactionModal, :popUp, :combatModal, :controller, :zoneCtrl, :window
  
  def initialize()
    @initialisee=false
  end
  
  def Vue.creer()
   new()
  end

  def defM(modele)
    @modele = modele
  end

  def defC(controller)
    @controller=controller
  end

  def initInterface()
    Gtk.init()
    
    @initialisee=true
    
    @inventaireModal=InventaireModal.creer(self)
    
    @tailleCase=130
    @tailleCase_f=@tailleCase.to_f
    
    @finInit = false;
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)

    @hauteurAfficheCarte = 4
    @largeurAfficheCarte = 8
    #matrice de stockage
    @vue = Array.new(@hauteurAfficheCarte){|x|Array.new(@largeurAfficheCarte ){|y|Gtk::Image.new()}}
    @zaf = Zaf.new()
    #@menu = MenuJeu.creer(true, @modele, @controller)
    @zoneCtrl = ZoneCtrl.creer(self,@controller)
    @carte = @modele.carte
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

=begin
    
    @window.signal_connect('size_request'){

      x = (@window.size()[0]-1)/@tailleCase;
      y = (@window.size()[1]-177)/@tailleCase; #177 = taille de la zaf

      #puts @window.size()[0].to_s+" "+@window.size()[1].to_s
      if((@largeurAfficheCarte != x) || (@hauteurAfficheCarte != y))  then
        if((x>=@largeurAfficheCarte && y >=@hauteurAfficheCarte))then
          if(@carteVue != nil && @finInit)then
            @largeurAfficheCarte = x;
            @hauteurAfficheCarte = y;
            @vue = Array.new(@hauteurAfficheCarte){Array.new(@largeurAfficheCarte ){Gtk::Image.new()}}
            initCarte();
            @x=@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2
            @y=@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2
            afficheCarte()
            @window.show_all()
        
          end
        end
      end
    }
    
=end
   
    bloquerEcouteClavier()
    @controller.ecouteClavierCreer(@window)
    #tableau pour le bas de la fenêtre
    tabBot = Gtk::Table.new(1,3,true)

    tabBot.attach(@zaf,0,2,0,1)
    tabBot.attach(@zoneCtrl,2,3,0,1)

    #image pour afficher la carte
    @timeout_id=nil
    @delay=10
    @numEtapeAffichage=0
    @nbEtapeAffichage=50
    @positions=Array.new([[@tailleCase_f/3,@tailleCase_f/3],[@tailleCase_f/3,0.1],[0.1,@tailleCase_f/3],
                          [2*@tailleCase_f/3,@tailleCase_f/3],[@tailleCase_f/3,2*@tailleCase_f/3],[0.1,0.1]])
    
    @structureEnnemisDeplacement  = Array.new()      
    @structureAidesGenere = Array.new()   
    @background = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique("blanc")) 
    @background=@background.scale(@tailleCase*@largeurAfficheCarte, @tailleCase*@hauteurAfficheCarte,Gdk::Pixbuf::INTERP_BILINEAR)
    @frame = Gdk::Pixbuf.new(Gdk::Pixbuf::COLORSPACE_RGB,false, 8,@background.width, @background.height)
    @carteVue = Gtk::DrawingArea.new
    @carteVue.set_size_request(@background.width, @background.height)
    @carteVue.signal_connect('expose_event') do |w, e|
          expose(w, e)
    end
        
    vbox = Gtk::VBox.new()

    #initialisation de la carte

    initCarte();
    @x=@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2
    @y=@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2
    #afficheCarte()
    
    #valign = Alignment.new(0.5,1,0,0);
    #valign.add(@carteVue);
    #vbox.add(valign)
    
    vbox.add(@carteVue)
    valignBot = Alignment.new(0.5,1,1,0)
    valignBot.add(tabBot)
    vbox.add(valignBot)
    
    window.set_resizable(false)
    @window.add(vbox)

    @window.set_title("THE GAME")

    @window.show_all()
	
    #lancé ici car on a pas encore de bouton debut partie
    @modele.debutTour()
    @finInit = true;
    Gtk.main();
  end

  def initCarte()
    
=begin

    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carteVue.attach(@vue[x][y],y,y+1,x,x+1)
      end
    end
    
=end

  end

  
  def afficheCarte()
    @structureEnnemisDeplacement.clear()
    @structureAidesGenere.clear()
    
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carte.getCaseAt(x+@x,y+@y).verifEnnemis # A METTRE AILLEUR -> VUE MODIF PAS MODELE
        afficheCase(y*@tailleCase,x*@tailleCase,@carte.getCaseAt(x+@x,y+@y))
        #POUR UN PIXBUF, AXE X ET Y SONT INVERSE PAR RAPOORT AUX NOTRES
      end
    end
    @carteVue.window.draw_pixbuf(nil, @background, 0, 0, 0, 0, @background.width, @background.height, Gdk::RGB::DITHER_NORMAL, 0, 0)
                  
  end
  
  
  def afficheCarteDyn()
    @structureEnnemisDeplacement.clear()
    @structureAidesGenere.clear()
    
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carte.getCaseAt(x+@x,y+@y).verifEnnemis # A METTRE AILLEUR -> VUE MODIF PAS MODELE
        afficheCaseDyn(y*@tailleCase,x*@tailleCase,@carte.getCaseAt(x+@x,y+@y))
        #POUR UN PIXBUF, AXE X ET Y SONT INVERSE PAR RAPOORT AUX NOTRES
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

  
  
  
  
  
def afficheCase(xAff,yAff,caseAffiche)
 
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
       @background.composite!(pixbufElement, xAff+x,yAff+y, pixbufElement.width, pixbufElement.height,xAff+x, yAff+y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
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
       
       @background.composite!(pixbufElement, xArr,yArr, pixbufElement.width, pixbufElement.height,xArr,yArr,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
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
            when EnumDirection.SUD
              pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"S"))
            when EnumDirection.EST
              pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"E"))
            when EnumDirection.OUEST
              pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase+"O"))
          end
        pixbufElement=pixbufElement.scale(@tailleCase_f/3, @tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
        
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
          @structureEnnemisDeplacement.push([traitement,nil,nil,xArr,yArr,pixbufElement])
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
            
            @structureEnnemisDeplacement.push([traitement,xDep,yDep,xArr,yArr,pixbufElement])
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
    @window.modal=true

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
          afficheCarteDyn()
        else
          afficheCarte()
        end
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
        else
          x=xDep+@numEtapeAffichage*(xArr-xDep)/@nbEtapeAffichage
          y=yDep+@numEtapeAffichage*(yArr-yDep)/@nbEtapeAffichage
          @frame.composite!(pixbuf,x,y,pixbuf.width, pixbuf.height,x, y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
        end
      end
      
      @carteVue.queue_draw
      if(@numEtapeAffichage==@nbEtapeAffichage)
              Gtk.timeout_remove(@timeout_id)
              @numEtapeAffichage=0       
              @timeout_id=nil
              majEcouteClavier()
              @zoneCtrl.majBoutons(@modele)
      end    
      true
    end
  
end





