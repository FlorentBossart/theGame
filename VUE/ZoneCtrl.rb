#!/usr/bin/env ruby

##
# Fichier            : ZoneCtrl.rb
# Auteur            : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la zone de controle en bas a droite du jeu, avec les boutons d'intération
#
require 'gtk2'
require 'XMLReader/XmlMultilingueReader.rb'
require 'CONTROLEUR/Controller.rb'

class ZoneCtrl <  Gtk::Frame
  private_class_method :new

  @vue #la vue
  @controller #le controller pour l'association des bouton
  @gauche #le bouton gauche
  @droite #le bouton droite
  @haut #le bouton haut
  @bas #le bouton bas
  @repos #le bouton repos
  @inventaire #le bouton de l'inventaire
  @menu #le bouton menu
  @interaction #le bouton d'interaction
  
  def initialize(vue,controller)
    super() #Frame
    @vue=vue
    @controller=controller
    initInterface()
  end

  def ZoneCtrl.creer(vue,controller)
    new(vue,controller)
  end

  def initInterface()
    #creation image bouton
    @gauche = Gtk::EventBox.new.add(Gtk::Image.new(@vue.referencesGraphiques.getRefGraphique("gauche")))
    @droite = Gtk::EventBox.new.add(Gtk::Image.new(@vue.referencesGraphiques.getRefGraphique("droite")))
    @haut = Gtk::EventBox.new.add(Gtk::Image.new(@vue.referencesGraphiques.getRefGraphique("haut")))
    @bas = Gtk::EventBox.new.add(Gtk::Image.new(@vue.referencesGraphiques.getRefGraphique("bas")))
    #association au controlleur
    @controller.deplacementGaucheCreer(@gauche)
    @controller.deplacementDroiteCreer(@droite)
    @controller.deplacementHautCreer(@haut)
    @controller.deplacementBasCreer(@bas)
    #creation bouton
    @repos = Gtk::Button.new(XmlMultilingueReader.lireTexte("boutonRepos"))
    @inventaire = Gtk::Button.new(XmlMultilingueReader.lireTexte("boutonInventaire"))
    @menu = Gtk::Button.new(XmlMultilingueReader.lireTexte("boutonMenu"))
    @interaction = Gtk::Button.new(XmlMultilingueReader.lireTexte("boutonInteraction"))
    #association au controler
    @controller.reposCreer(@repos)
    @controller.inventaireCreer(@inventaire)
    @controller.menuCreer(@menu)
    @controller.interactionCreer(@interaction)

    vbox = Gtk::VBox.new(true, 3)
    hbox1 = Gtk::HBox.new(true, 3)
    hbox2 = Gtk::HBox.new(true, 3)
    hbox3 = Gtk::HBox.new(true, 3)

    vbox.add(hbox1)
    vbox.add(hbox2)
    vbox.add(hbox3)
    #ligne 1
    hbox1.add(@repos)
    hbox1.add(@haut)
    hbox1.add(@inventaire)

    #ligne2
    hbox2.add(@gauche)
    hbox2.add(Gtk::Label.new(""))
    hbox2.add(@droite)

    #ligne3
    hbox3.add(@menu)
    hbox3.add(@bas)
    hbox3.add(@interaction)

    add(vbox);
    show_all();
  end

  #rend les boutons actif ou non celon cla présence d'eau
  def majBoutons(modele)
    @haut.sensitive=modele.joueur.casePosition.caseNord.estAccessible?()
    @bas.sensitive=modele.joueur.casePosition.caseSud.estAccessible?()
    @gauche.sensitive=modele.joueur.casePosition.caseOuest.estAccessible?()
    @droite.sensitive=modele.joueur.casePosition.caseEst.estAccessible?()
    @repos.sensitive=modele.joueur.nombreRepos!=0
    @inventaire.sensitive=!modele.joueur.inventaire.items.empty?()
    @interaction.sensitive=modele.joueur.casePosition.presenceAides?()
  end

  #bloque tout les boutons lors d'un déplacement
  def bloquerBoutons(modele)
    @haut.sensitive=false
    @bas.sensitive=false
    @gauche.sensitive=false
    @droite.sensitive=false
    @repos.sensitive=false
    @inventaire.sensitive=false
    @interaction.sensitive=false
  end

  #mise a jour de la langue
  def majLangue()
    @repos.label=(XmlMultilingueReader.lireTexte("boutonRepos"))
    @inventaire.label=(XmlMultilingueReader.lireTexte("boutonInventaire"))
    @menu.label=(XmlMultilingueReader.lireTexte("boutonMenu"))
    @interaction.label=(XmlMultilingueReader.lireTexte("boutonInteraction"))
  end
end

