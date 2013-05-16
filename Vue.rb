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

class Vue

  @vue; #affichage carte
  @zaf
  @menu
  @zoneCtrl;
  @carte; #la classe carte
  @referencesGraphiques; #fichier xml des images
  @carteVue; #tableau pour affichager la carte
  @hauteurAfficheCarte; #hauteurVisible
  @largeurAfficheCarte; #largeurVisible
  @modele
  @controller
  @x #coordonné actuel
  @y #coordonné actuel
  @combatModal
  @interactionModal
  @popUp
  @window
  @valign
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
  
  @@threadAffichage = false 

  attr_reader :hauteurAfficheCarte, :largeurAfficheCarte, :ecouteUp, :ecouteDown, :ecouteLeft, :ecouteRight, :ecouteToucheRepos, :ecouteToucheInventaire, :ecouteToucheMenu, :ecouteToucheInteraction
  attr_accessor :x , :y, :menu, :interactionModal, :popUp, :combatModal, :controller, :zoneCtrl, :window
  def initialize()
    #Gtk.init();
    #@carteVue = Modele.carte;
    #initInterface();
    #Gtk.main();

  end

  def defM(modele)
    @modele = modele
  end

  def defC(controller)
    @controller=controller
  end

  def initInterface()
    Gtk.init();
    @finInit = false;
    @referencesGraphiques = ReferencesGraphiques.new()
    XmlRefGraphiquesReader.lireXml(@referencesGraphiques)

    @tailleCase= 100;
    @hauteurAfficheCarte = 5
    @largeurAfficheCarte = 11
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
      Gtk.main_quit()
    }

    @window.signal_connect('size_request'){

      x = (@window.size()[0]-1)/@tailleCase;
      y = (@window.size()[1]-169)/@tailleCase; #169 = taille de la zaf

      #puts @window.size()[0].to_s+" "+@window.size()[1].to_s
      if((@largeurAfficheCarte != x) || (@hauteurAfficheCarte != y))  then
        if((x>=9 && y >=5))then
          if(@carteVue != nil && @finInit)then
            @largeurAfficheCarte = x;
            @hauteurAfficheCarte = y;
            @valign.remove(@carteVue);
            @vue = Array.new(@hauteurAfficheCarte){Array.new(@largeurAfficheCarte ){Gtk::Image.new()}}
            @carteVue = Gtk::Table.new(@hauteurAfficheCarte,@largeurAfficheCarte,true)
            initCarte();
            @valign.add(@carteVue);
            afficheCarte(@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2,@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2);
            @window.show_all()
        
          end
        end
      end
    }

    bloquerEcouteClavier()
    @controller.ecouteClavierCreer(@window)
    #tableau pour le bas de la fenêtre
    tabBot = Gtk::Table.new(1,3,true)

    tabBot.attach(@zaf,0,2,0,1)
    tabBot.attach(@zoneCtrl,2,3,0,1)

    #tableau pour afficher la carte
    @carteVue = Gtk::Table.new(@hauteurAfficheCarte,@largeurAfficheCarte,true)

    vbox = Gtk::VBox.new()

    #initialisation de la carte

    #initialisation de la carte

    initCarte();
    afficheCarte(@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2,@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2);
    @valign = Alignment.new(0.5,1,0,0);
    @valign.add(@carteVue);

    vbox.add(@valign)
    valignBot = Alignment.new(0.5,1,1,0);
    valignBot.add(tabBot);
    vbox.add(valignBot);

    #window.set_resizable(false)
    @window.add(vbox)

    @window.set_title("THE GAME")

    @window.show_all()

    #lancé ici car on a pas encore de bouton debut partie
    @modele.debutTour()
    @finInit = true;
    Gtk.main();
  end

  def initCarte()
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        @carteVue.attach(@vue[x][y],y,y+1,x,x+1)
      end
    end

  end

  def afficheCarte(debutX,debutY)
    @x=debutX
    @y=debutY
    0.upto(@hauteurAfficheCarte-1) do |x|
      0.upto(@largeurAfficheCarte-1)do |y|
        afficheCase(@vue[x][y],@carte.getCaseAt(x+debutX,y+debutY))
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

  def afficheCase(image,caseAffiche)
    tailleCase=100
    tailleCase_f=tailleCase.to_f
    positions=Array.new([[0.1,0.1],[2*tailleCase_f/3,0.1],[0.1,2*tailleCase_f/3],[2*tailleCase_f/3,2*tailleCase_f/3],[tailleCase_f/3,0.1]])

    #test Bordures
    pixbufTerrain = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.getIntitule().downcase))
    pixbufTerrain=pixbufTerrain.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
    
	Thread.new do
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseNord.getIntitule().downcase)).to_s()+"1"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    
    end

	Thread.new do
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseEst.getIntitule().downcase)).to_s()+"2"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
	end
	end
    
	Thread.new do
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseSud.getIntitule().downcase)).to_s()+"3"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    end

	Thread.new do
    if((getNumTerrain(caseAffiche.getIntitule().downcase))<(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)))
      idImage="bordure"+(getNumTerrain(caseAffiche.caseOuest.getIntitule().downcase)).to_s()+"4"
      pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
      pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end
    end
    #terrain
    #pixbufTerrain = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(@modele.id_terrainParDefaut.downcase))
    #pixbufTerrain=pixbufTerrain.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)

    #if(caseAffiche.getIntitule().downcase=="eau")#a fr pour tous si ça marche
    # voisin_differents=Array.new(['0','0','0','0'])
    #if caseAffiche.caseNord.getIntitule()!=caseAffiche.getIntitule()
    #  voisin_differents[0]='1'
    # end
    # if caseAffiche.caseEst.getIntitule()!=caseAffiche.getIntitule()
    #  voisin_differents[1]='1'
    # end
    # if caseAffiche.caseSud.getIntitule()!=caseAffiche.getIntitule()
    #  voisin_differents[2]='1'
    #end
    # if caseAffiche.caseOuest.getIntitule()!=caseAffiche.getIntitule()
    #   voisin_differents[3]='1'
    # end
    # idImage=caseAffiche.getIntitule().downcase()+voisin_differents[0]+voisin_differents[1]+voisin_differents[2]+voisin_differents[3]
    #pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(idImage))
    #else
    # pixbufTerrainSurcouche = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.getIntitule().downcase))
    # end
    #pixbufTerrainSurcouche=pixbufTerrainSurcouche.scale(tailleCase, tailleCase,Gdk::Pixbuf::INTERP_BILINEAR)
    #pixbufTerrain.composite!(pixbufTerrainSurcouche, 0,0, pixbufTerrainSurcouche.width, pixbufTerrainSurcouche.height,0, 0,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)

    #joueur
    if(caseAffiche.joueur!=nil)
      pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(caseAffiche.joueur.getIntitule().downcase))
      pixbufElement=pixbufElement.scale(tailleCase_f/2, tailleCase_f/2,Gdk::Pixbuf::INTERP_BILINEAR)
      x=tailleCase_f/3
      y=tailleCase_f/3
      pixbufTerrain.composite!(pixbufElement, x,y, pixbufElement.width, pixbufElement.height,x, y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    #aides+ennemis
    aidesEnnemis=caseAffiche.listeElements+caseAffiche.listeEnnemis
    for e in aidesEnnemis
      if(positions.empty?)
        return nil
      end
      position=positions.shift()
      x=position[0]
      y=position[1]
      pixbufElement = Gdk::Pixbuf.new(@referencesGraphiques.getRefGraphique(e.getIntitule().downcase))
      pixbufElement=pixbufElement.scale(tailleCase_f/3, tailleCase_f/3,Gdk::Pixbuf::INTERP_BILINEAR)
      pixbufTerrain.composite!(pixbufElement, x,y, pixbufElement.width, pixbufElement.height,x, y,1, 1, Gdk::Pixbuf::INTERP_NEAREST,255)
    end

    image.set_pixbuf(pixbufTerrain)
    return nil
  end

  def getZaf()
    return @zaf
  end

  def actualiser
    @window.modal=true

    puts "debut actualiser"
    
    if(@@threadAffichage == false)
		@@threadAffichage = true
		@modele.enverDuDecors
		Thread.new do
			while(true) do
				#maj Carte Et Zaf
				afficheCarte(@modele.joueur.casePosition.coordonneeX-@hauteurAfficheCarte/2,@modele.joueur.casePosition.coordonneeY-@largeurAfficheCarte/2)
				@zaf.majZaf(@modele.joueur)
				sleep(0.01)		
			end
		end
	end
    case @modele.stadePartie

    #ETAPE CHOIX LIBRE
    when EnumStadePartie.CHOIX_LIBRE
      @zoneCtrl.majBoutons(@modele)
      majEcouteClavier()
      #ETAPE PARTIE PERDUE
    when EnumStadePartie.PERDU
      XmlClassements.ecrireXml(@modele)
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
    puts "fin actualiser"
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
end
