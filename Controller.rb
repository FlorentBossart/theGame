#!/usr/bin/env ruby

##
# Fichier        : Controller.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente le Controlleur du jeu
#h

require 'Vue.rb'
require 'Audio.rb'


class Controller

   @modele
   @vue

   ##
   # Crée un nouveau Controlleur à partir de la Vue et du Modele passés en paramètre.
   #
   # == Parameters:
   # modele : le Modele du jeu
   # vue    : la Vue du jeu
   #
   def initialize(modele, vue)
      @modele = modele
      @vue    = vue
      #Audio.load()
      #Audio.playSoundLoop("mario")
   end
   
   def Controller.creer(modele,vue)
     new(modele,vue)
   end

    
    
     
  ##
  #  Fait le lien entre un bouton et l'action liée au deplacement haut
  #
  # == Parameters:
  # btDeplacementHaut : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le haut
  #
  def deplacementHautCreer(btDeplacementHaut)
      btDeplacementHaut.signal_connect('button_press_event'){
        deplacementHautAction()
      }
  end
      

             
  ##
  # Action(s) à effectuer lors du clic sur le bouton de deplacement haut
  #
  def deplacementHautAction
    #print "/\ Bt déplacement haut pressé!\n"
     Audio.playSound("deplacement")
     @modele.joueur.deplacement(EnumDirection.NORD)
     @modele.debutTour()
  end

    
    
  ##
  # Fait le lien entre un bouton et l'action liée au deplacement bas
  #
  # == Parameters:
  # btDeplacementBas : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le bas
  #
  def deplacementBasCreer(btDeplacementBas)
      btDeplacementBas.signal_connect('button_press_event'){
        deplacementBasAction()
      }
  end
        

   ##
   # Action(s) à effectuer lors du clic sur le bouton deplacement bas
   #
  def deplacementBasAction
    #print "\/ Bt déplacement bas pressé!\n"
     Audio.playSound("deplacement")
     @modele.joueur.deplacement(EnumDirection.SUD)
     @modele.debutTour()
  end
 
    
   ##
   # Fait le lien entre un bouton et l'action liée au deplacement gauche
   #
   # == Parameters:
   # btDeplacementGauche : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la gauche
   #
  def deplacementGaucheCreer(btDeplacementGauche)
     btDeplacementGauche.signal_connect('button_press_event'){
       deplacementGaucheAction()
     }
  end
        
   ##
   # Action(s) à effectuer lors du clic sur le bouton de deplacement gauche
   #
  def deplacementGaucheAction
    #print "<< Bt déplacement gauche pressé!\n"
     Audio.playSound("deplacement")
    @modele.joueur.deplacement(EnumDirection.OUEST)
    @modele.debutTour()
  end
        

    
  
        
   ##
   # Fait le lien entre un bouton et l'action liée au deplacement droit
   #
   # == Parameters:
   # btDeplacementDroite : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la droite
   #
  def deplacementDroiteCreer(btDeplacementDroite)
      btDeplacementDroite.signal_connect('button_press_event'){
          deplacementDroiteAction()
        }
    end
        
  
        
  ##
  # Action(s) à effectuer lors du clic sur le bouton de deplacement droit
  #
  def deplacementDroiteAction
    #print ">> Bt déplacement droite pressé!\n"
     Audio.playSound("deplacement")
    @modele.joueur.deplacement(EnumDirection.EST)
    @modele.debutTour()
  end
        

        
   ##
   # Fait le lien entre un bouton et l'action liée au repos
   #
   # == Parameters:
   # btRepos : le gtkButton qu'il faudra lier à l'action d'un repos
   #
  def reposCreer(btRepos)
      btRepos.signal_connect('clicked'){
          reposAction()
        }
    end
        
   ##
   # Action(s) à effectuer lors du clic sur le bouton repos
   #
  def reposAction
    print "ZZzzzZZZzzzz Bt repos pressé!\n"
    @modele.joueur.utiliserRepos() 
    @modele.debutTour()
  end

    
        
   ##
   #  Fait le lien entre un bouton et l'action liée à l'affichage de l'inventaire
   #
   # == Parameters:
   # btInventaire : le gtkButton qu'il faudra lier à l'action du clic sur le bouton inventaire
   #
  def inventaireCreer(btInventaire)
     btInventaire.signal_connect('clicked'){
        inventaireAction()
      }
  end
        

  ##
  # Action(s) à effectuer lors du clic sur le bouton inventaire
  #
  def inventaireAction
    print "oO Bt inventaire pressé!"
  end


   ##
   # Fait le lien entre un bouton et l'action liée à l'affichage du menu
   #
   # == Parameters:
   # btMenu : le gtkButton qu'il faudra lier aux actions d'affichage du menu
   #
  def menuCreer(btMenu)
      btMenu.signal_connect('clicked'){
        menuAction()
      }
  end
        
        
  ##
  # Action(s) à effectuer lors du clic sur le bouton menu
  #
  def menuAction
    puts "<--> Creation du menu"
    @vue.menu = MenuJeu.creer(true, @modele, self)
    puts "-- Affichage du menu"
    @vue.menu.afficherMenu()
  end

    
  ##
  # Fait le lien entre un bouton et l'action liée au menu d'interactions
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
  #
  def interactionCreer(btInteraction)
      btInteraction.signal_connect('clicked'){
        interactionAction()
      }
  end
        
   
        
  ##
  # Action(s) à effectuer lors du clic sur le bouton interaction
  #
  def interactionAction()
    print "oO Bt interaction pressé!"
    #@vue.zoneCtrl.bloquerBoutons(@modele)
    @vue.interactionModal.majInteractionModal()
  end

    

      
  ##
  # Fait le lien entre un bouton et l'action liée a un element
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
  # elem : element avec lequel on souhaite interagir
  # joueur : afin d'effectuer l'action de l'element sur le joueur
  # dialog: popup lié au bouton
  #
  def interactionElementCreer(btInteraction,elem,joueur,dialog)
      btInteraction.signal_connect('clicked'){
        interactionElementAction(elem,joueur)
        dialog.destroy
     }
  end
      
      
  ##
  # Action(s) à effectuer lors du clic sur un bouton <element>
  #
  # == Parameters:
  # elem : element avec lequel on souhaite interagir
  # joueur : afin d'effectuer l'action de l'element sur le joueur
  #
  def interactionElementAction(elem,joueur)
    print "oO Bt interaction "+elem.getIntitule+" pressé!"
     Audio.playSound("coin")
    elem.interaction(joueur)
    @modele.debutTour()
  end
  
  
  ##
  # Fait le lien entre un bouton et l'action liée a un menu d'achat
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
  # dialog: popup lié au bouton
  #
  def achatMarchandCreer(btInteraction,dialog)
  btInteraction.signal_connect('clicked'){

    achatMarchandAction()
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) à effectuer lors du clic sur le bouton d'achat
  #
  def achatMarchandAction()
    print "oO Bt achatMarchandAction  pressé!"
    @modele.debutTour()
  end
  
  
  ##
  # Fait le lien entre un bouton et l'action liée a un menu de vente
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
  # dialog: popup lié au bouton
  #
  def vendreMarchandCreer(btInteraction,dialog)
  btInteraction.signal_connect('clicked'){

    vendreMarchandAction()
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) à effectuer lors du clic sur le bouton de vente
  #
  def vendreMarchandAction()
    print "oO Bt venndreMarchandAction  pressé!"
    @modele.debutTour()
  end
      
  
  ##
  # Fait le lien entre un bouton et l'action liée au soin
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
  # joueur : le joueur qui doit recevoir le soin
  # choix : integer correspondant au soin choisi
  # guerisseur : le guerisseur repondant a la demande de soin
  # dialog: popup lié au bouton
  #
  def soinCreer(btInteraction,joueur, choix, guerisseur,dialog)
  btInteraction.signal_connect('clicked'){

    soinAction(joueur,choix,guerisseur)
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) à effectuer lors du clic sur le bouton de soins
  #
  # == Parameters:
  # joueur : le joueur qui doit recevoir le soin
  # choix : integer correspondant au soin choisi
  # guerisseur : le guerisseur repondant a la demande de soin
  #
  def soinAction(joueur,choix,guerisseur)
    guerisseur.guerrir(joueur,choix)
    @modele.debutTour()
  end
      
  
  ##
  # equipe un item lors de l'appuie sur le bouton correspondant
  #
  # == Parameters:
  # joueur : le joueur qui doit equiper l'item
  # elem : element a equiper
  # dialog: popup lié au bouton
  #
  def equiperItemCreer(btInteraction,elem,joueur,dialog)
      btInteraction.signal_connect('clicked'){
        equiperItemAction(joueur,elem)
        dialog.destroy
     }
  end
      
      
  ##
  # Action(s) à effectuer lors du clic sur le bouton d'equipement d'element
  #
  # == Parameters:
  # joueur : le joueur qui doit equiper l'item
  # elem : element a equiper
  #
  def equiperItemAction(joueur,elem)
    joueur.utiliserItem(elem)
    print "oO Bt interaction "+elem.getIntitule()+" pressé!"
  end
  
  
  
  ## AFR
  # Sélectionne un item lors de l'appuie sur le bouton qui lui correspond dans l'inventaire
  #
  def selectionnerItem(btItem,indiceItem)
      btItem.signal_connect('button_press_event'){
        #equiperItemAction(joueur,elem)
        puts "(S) Sélection de l'item "+indiceItem.to_s+"."
        #InventaireVue.
     }
  end
  
##### Pour le menu  
  
  ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btNewPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur NouvellePartie
   #
   def nouvellePartieCreer(btNewPartie)
      btNewPartie.signal_connect('clicked'){
          nouvellePartieAction()
      }
   end
     
          
	##
	# Action(s) � effectuer lors du clic sur le bouton NouvellePartie
	#
	def nouvellePartieAction
		puts "Clique sur nouvelle partie"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherNouvellePartie()
	end

      
   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btChargerPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur ChargerPartie
   #
   def chargerPartieCreer(btChargerPartie)
      btChargerPartie.signal_connect('clicked'){
          chargerPartieAction()
      }
   end  
          
	##
	# Action(s) � effectuer lors du clic sur le bouton ChargerPartie
	#
	def chargerPartieAction
		puts "Clique sur charger partie"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherChargerPartie()
	end

   
   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btSauvegarderPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur SauvegarderPartie
   #
   def sauvegarderPartieCreer(btSauvegarderPartie)
      btSauvegarderPartie.signal_connect('clicked'){
          sauvegarderPartieAction()
      }
   end
 
          
	##
	# Action(s) � effectuer lors du clic sur le bouton SauvegarderPartie
	#
	def sauvegarderPartieAction
		puts "Clique sur sauvegarder partie"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherSauvegarderPartie()
	end



   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btClassement : le gtkButton qu'il faudra lier � l'action d'un clic sur Classement
   #
   def classementCreer(btClassement)
      btClassement.signal_connect('clicked'){
          classementAction()
      }
   end
   
          
	##
	# Action(s) � effectuer lors du clic sur le bouton Classement
	#
	def classementAction
		puts "Clique sur classement"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherClassement()
	end


   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btOptions : le gtkButton qu'il faudra lier � l'action d'un clic sur Options
   #
   def optionsCreer(btOptions)
      btOptions.signal_connect('clicked'){
          optionsAction()
      }
   end
 
  
	##
	# Action(s) � effectuer lors du clic sur le bouton Options
	#
	def optionsAction
		puts "Clique sur options"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherOptions()
	end

   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btAide : le gtkButton qu'il faudra lier � l'action d'un clic sur Aide
   #
   def aideCreer(btAide)
      btAide.signal_connect('clicked'){
          aideAction()
      }
   end
    
          
	##
	# Action(s) � effectuer lors du clic sur le bouton Aide
	#
	def aideAction
		puts "Clique sur aide"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherAide()
	end


   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btRetour : le gtkButton qu'il faudra lier � l'action d'un clic sur Retour
   #
   def retourCreer(btRetour)
      btRetour.signal_connect('clicked'){
          retourAction()
      }
   end
 
 
	##
	# Action(s) � effectuer lors du clic sur le bouton Retour
	#
	def retourAction
		puts "Clique sur Retour"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherMenu()
	end
      
end


