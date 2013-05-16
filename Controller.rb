#!/usr/bin/env ruby

##
# Fichier        : Controller.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe reprÃ©sente le Controlleur du jeu
# 

require 'Vue.rb'
require 'Audio.rb'
require 'XMLReader/XmlMultilingueReader.rb'


class Controller

   @modele
   @vue

   ##
   # CrÃ©e un nouveau Controlleur Ã  partir de la Vue et du Modele passÃ©s en paramÃ¨tre.
   #
   # == Parameters:
   # modele : le Modele du jeu
   # vue    : la Vue du jeu
   #
   def initialize(modele, vue)
      @modele = modele
      @vue    = vue
      #Audio.playSoundLoop("stable_boy")
   end
   
   def Controller.creer(modele,vue)
     new(modele,vue)
   end

    
   def ecouteClavierCreer(window)
     window.signal_connect("key-press-event") do |w, e|
       case Gdk::Keyval.to_name(e.keyval)
          when "Up"
            if @vue.ecouteUp
              deplacementHautAction()
            end
          when "Down"
            if @vue.ecouteDown
              deplacementBasAction()
            end
          when "Right"
            if @vue.ecouteRight
              deplacementDroiteAction()
            end
          when "Left"
            if @vue.ecouteLeft
              deplacementGaucheAction()
            end
          when XmlMultilingueReader.lireTexte("clavierRepos")
            if @vue.ecouteToucheRepos
              reposAction()
            end
          when XmlMultilingueReader.lireTexte("clavierInventaire")
            if @vue.ecouteToucheInventaire
              inventaireAction()
            end
          when XmlMultilingueReader.lireTexte("clavierInteraction")
            if @vue.ecouteToucheInteraction
              interactionAction()
            end
          when XmlMultilingueReader.lireTexte("clavierMenu")
            if @vue.ecouteToucheMenu
              menuAction()
            end
       end
     end
   end 
     
  ##
  #  Fait le lien entre un bouton et l'action liÃ©e au deplacement haut
  #
  # == Parameters:
  # btDeplacementHaut : le gtkButton qu'il faudra lier Ã  l'action d'un dÃ©placement vers le haut
  #
  def deplacementHautCreer(btDeplacementHaut)
      btDeplacementHaut.signal_connect('button_press_event'){
        deplacementHautAction()
      }
  end
      

             
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton de deplacement haut
  #
  def deplacementHautAction
    #print "/\ Bt dÃ©placement haut pressÃ©!\n"
     Audio.playSound("deplacement")
     @modele.joueur.deplacement(EnumDirection.NORD)
     @modele.debutTour()
  end

    
    
  ##
  # Fait le lien entre un bouton et l'action liÃ©e au deplacement bas
  #
  # == Parameters:
  # btDeplacementBas : le gtkButton qu'il faudra lier Ã  l'action d'un dÃ©placement vers le bas
  #
  def deplacementBasCreer(btDeplacementBas)
      btDeplacementBas.signal_connect('button_press_event'){
        deplacementBasAction()
      }
  end
        

   ##
   # Action(s) Ã  effectuer lors du clic sur le bouton deplacement bas
   #
  def deplacementBasAction
    #print "\/ Bt dÃ©placement bas pressÃ©!\n"
     Audio.playSound("deplacement")
     @modele.joueur.deplacement(EnumDirection.SUD)
     @modele.debutTour()
  end
 
    
   ##
   # Fait le lien entre un bouton et l'action liÃ©e au deplacement gauche
   #
   # == Parameters:
   # btDeplacementGauche : le gtkButton qu'il faudra lier Ã  l'action d'un dÃ©placement vers la gauche
   #
  def deplacementGaucheCreer(btDeplacementGauche)
     btDeplacementGauche.signal_connect('button_press_event'){
       deplacementGaucheAction()
     }
  end
        
   ##
   # Action(s) Ã  effectuer lors du clic sur le bouton de deplacement gauche
   #
  def deplacementGaucheAction
    #print "<< Bt dÃ©placement gauche pressÃ©!\n"
     Audio.playSound("deplacement")
    @modele.joueur.deplacement(EnumDirection.OUEST)
    @modele.debutTour()
  end
        

    
  
        
   ##
   # Fait le lien entre un bouton et l'action liÃ©e au deplacement droit
   #
   # == Parameters:
   # btDeplacementDroite : le gtkButton qu'il faudra lier Ã  l'action d'un dÃ©placement vers la droite
   #
  def deplacementDroiteCreer(btDeplacementDroite)
      btDeplacementDroite.signal_connect('button_press_event'){
          deplacementDroiteAction()
        }
    end
        
  
        
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton de deplacement droit
  #
  def deplacementDroiteAction
    #print ">> Bt dÃ©placement droite pressÃ©!\n"
     Audio.playSound("deplacement")
    @modele.joueur.deplacement(EnumDirection.EST)
    @modele.debutTour()
  end
        

        
   ##
   # Fait le lien entre un bouton et l'action liÃ©e au repos
   #
   # == Parameters:
   # btRepos : le gtkButton qu'il faudra lier Ã  l'action d'un repos
   #
  def reposCreer(btRepos)
      btRepos.signal_connect('clicked'){
          reposAction()
        }
    end
        
   ##
   # Action(s) Ã  effectuer lors du clic sur le bouton repos
   #
  def reposAction
    #print "ZZzzzZZZzzzz Bt repos pressÃ©!\n"
    Audio.playSound("ronfle")
    @modele.joueur.utiliserRepos() 
    @modele.debutTour()
  end

    
        
   ##
   #  Fait le lien entre un bouton et l'action liÃ©e Ã  l'affichage de l'inventaire
   #
   # == Parameters:
   # btInventaire : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton inventaire
   #
  def inventaireCreer(btInventaire)
     btInventaire.signal_connect('clicked'){
        inventaireAction()
      }
  end
        

  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton inventaire
  #
  def inventaireAction
    print "oO Bt inventaire pressÃ©!"
  end


   ##
   # Fait le lien entre un bouton et l'action liÃ©e Ã  l'affichage du menu
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
  # Action(s) Ã  effectuer lors du clic sur le bouton menu
  #
  def menuAction
    puts "<--> Creation du menu"
    @vue.menu = MenuJeu.creer(true, @modele, self)
    puts "-- Affichage du menu"
    @vue.window.modal = false;
    @vue.menu.afficherMenu()
    @vue.window.set_sensitive(false)
  end

    
  ##
  # Fait le lien entre un bouton et l'action liÃ©e au menu d'interactions
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton interaction
  #
  def interactionCreer(btInteraction)
      btInteraction.signal_connect('clicked'){
        interactionAction()
      }
  end
        
   
        
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton interaction
  #
  def interactionAction()
    print "oO Bt interaction pressÃ©!"
    #@vue.zoneCtrl.bloquerBoutons(@modele)
    @vue.interactionModal.majInteractionModal()
  end

    

      
  ##
  # Fait le lien entre un bouton et l'action liÃ©e a un element
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton interaction
  # elem : element avec lequel on souhaite interagir
  # joueur : afin d'effectuer l'action de l'element sur le joueur
  # dialog: popup liÃ© au bouton
  #
  def interactionElementCreer(btInteraction,elem,joueur,dialog)
      btInteraction.signal_connect('clicked'){
        interactionElementAction(elem,joueur)
        dialog.destroy
     }
  end
      
      
  ##
  # Action(s) Ã  effectuer lors du clic sur un bouton <element>
  #
  # == Parameters:
  # elem : element avec lequel on souhaite interagir
  # joueur : afin d'effectuer l'action de l'element sur le joueur
  #
  def interactionElementAction(elem,joueur)
    print "oO Bt interaction "+elem.getIntitule+" pressÃ©!"
     Audio.playSound("coin")
    elem.interaction(joueur)
    @modele.debutTour()
  end
  
  
  ##
  # Fait le lien entre un bouton et l'action liÃ©e a un menu d'achat
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton interaction
  # dialog: popup liÃ© au bouton
  #
  def achatMarchandCreer(btInteraction,dialog)
  btInteraction.signal_connect('clicked'){

    achatMarchandAction()
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton d'achat
  #
  def achatMarchandAction()
    print "oO Bt achatMarchandAction  pressÃ©!"
    @modele.debutTour()
  end
  
  
  ##
  # Fait le lien entre un bouton et l'action liÃ©e a un menu de vente
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton interaction
  # dialog: popup liÃ© au bouton
  #
  def vendreMarchandCreer(btInteraction,dialog)
  btInteraction.signal_connect('clicked'){

    vendreMarchandAction()
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton de vente
  #
  def vendreMarchandAction()
    print "oO Bt venndreMarchandAction  pressÃ©!"
    @modele.debutTour()
  end
      
  
  ##
  # Fait le lien entre un bouton et l'action liÃ©e au soin
  #
  # == Parameters:
  # btInteraction : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton interaction
  # joueur : le joueur qui doit recevoir le soin
  # choix : integer correspondant au soin choisi
  # guerisseur : le guerisseur repondant a la demande de soin
  # dialog: popup liÃ© au bouton
  #
  def soinCreer(btInteraction,joueur, choix, guerisseur,dialog)
  btInteraction.signal_connect('clicked'){

    soinAction(joueur,choix,guerisseur)
    dialog.destroy
  }
  end
  
  
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton de soins
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
  # dialog: popup liÃ© au bouton
  #
  def equiperItemCreer(btInteraction,elem,joueur,dialog)
      btInteraction.signal_connect('clicked'){
        equiperItemAction(joueur,elem)
        dialog.destroy
     }
  end
      
      
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton d'equipement d'element
  #
  # == Parameters:
  # joueur : le joueur qui doit equiper l'item
  # elem : element a equiper
  #
  def equiperItemAction(joueur,elem)
    joueur.utiliserItem(elem)
    print "oO Bt interaction "+elem.getIntitule()+" pressÃ©!"
  end
  
  
  
  ## AFR
  # SÃ©lectionne un item lors de l'appuie sur le bouton qui lui correspond dans l'inventaire
  #
  def selectionnerItem(btItem,indiceItem)
      btItem.signal_connect('button_press_event'){
        #equiperItemAction(joueur,elem)
        puts "(S) SÃ©lection de l'item "+indiceItem.to_s+"."
        #InventaireVue.
     }
  end
  
##### Pour le menu  
  
  ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btContinuerPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur Continuer partie
   #
   def continuerPartieCreer(btContinuerPartie,fenetre)
      btContinuerPartie.signal_connect('clicked'){
          continuerPartieAction()
          fenetre.destroy()
      }
   end
   
          
	##
	# Action(s) à effectuer lors du clic sur le bouton ContinuerPartie
	#
	def continuerPartieAction()
		puts "Clique sur continuer partie"
		@vue.menu.fenetreMenu.destroy
		puts "Destruction du menu"
		@vue.window.set_sensitive(true)
	end
  
  
  ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btNewPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur NouvellePartie
   #
   def nouvellePartieCreer(btNewPartie,fenetre)
      btNewPartie.signal_connect('clicked'){
          nouvellePartieAction()
        fenetre.destroy()
      }
   end
     
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton NouvellePartie
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
   # btChargerPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur ChargerPartie
   #
   def chargerPartieCreer(btChargerPartie,fenetre)
      btChargerPartie.signal_connect('clicked'){
          chargerPartieAction()
          fenetre.destroy()
      }
   end  
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton ChargerPartie
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
   # btSauvegarderPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur SauvegarderPartie
   #
   def sauvegarderPartieCreer(btSauvegarderPartie,fenetre)
      btSauvegarderPartie.signal_connect('clicked'){
          sauvegarderPartieAction()
        fenetre.destroy()
      }
   end
 
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton SauvegarderPartie
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
   # btClassement : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Classement
   #
   def classementCreer(btClassement,fenetre)
      btClassement.signal_connect('clicked'){
          classementAction()
        fenetre.destroy()
      }
   end
   
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Classement
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
   # btOptions : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Options
   #
   def optionsCreer(btOptions,fenetre)
      btOptions.signal_connect('clicked'){
          optionsAction()
        fenetre.destroy()
      }
   end
 
  
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Options
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
   # btAide : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Aide
   #
   def aideCreer(btAide,fenetre)
      btAide.signal_connect('clicked'){
          aideAction()
          fenetre.destroy()
      }
   end
    
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Aide
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
   # btCommencerNewPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur "C'est Parti" dans nouvelle partie
   #
   def commencerNewPartieCreer(btCommencerNewPartie, entryPseudo, boutRadioNovice, boutRadioMoyen, boutRadioExpert,fenetre)
      btCommencerNewPartie.signal_connect('clicked'){
			entryPseudo.activate # Appel le signal_connect 'activate' sur l'entry du pseudo
        fenetre.destroy()
      }
      entryPseudo.signal_connect('activate'){
			commencerNewPartieAction(entryPseudo.text, boutRadioNovice, boutRadioMoyen, boutRadioExpert)
		}
   end
 
 
	##
	# Action(s) � effectuer lors du clic sur le bouton "C'est Parti" dans nouvelle partie
	#
	def commencerNewPartieAction(pseudo, boutRadioNovice, boutRadioMoyen, boutRadioExpert)
		puts "Clique sur C'est Parti"
		puts "pseudo : |" + pseudo + "|"
		if(boutRadioNovice.active?)
			puts "Difficulte choisi : Novice"
			difficulte = BibliothequeDifficulte.getDifficulte("Novice")
		elsif(boutRadioMoyen.active?)
			puts "Difficulte choisi : Moyen"
			difficulte = BibliothequeDifficulte.getDifficulte("Moyen")
		elsif(boutRadioExpert.active?)
			puts "Difficulte choisi : Expert"
			difficulte = BibliothequeDifficulte.getDifficulte("Expert")
		end
		
		# A enlever apres test
		difficulte = BibliothequeDifficulte.getDifficulte("difficulteDeTest")
		
		
		@vue.menu.fenetreMenu.destroy
		puts "destroy menu"
		@vue.window.destroy
		puts "Destroy partie"
		
		quitterPartieAction()
	
		#XmlMultilingueReader.setLangue("EN")
		#XmlMultilingueReader.setLangue("FR")
		puts "langue"
		
		# Remplissage des bibliothèque
		#Modele.initialisationBibliotheques()
		puts "modele init biblio"

		#Audio.load()

	
		# Creation de la vue
		vue=Vue.new()
		
		# Creation du modele
		modele = Modele.creer(vue,difficulte,pseudo)
		puts "modele creer"
		puts "difficulte : " + difficulte.to_s
		controller=Controller.creer(modele,vue)
		puts "controller creer"
		vue.defM(modele)
		vue.defC(controller)
		puts "vue defc"
		modele.initialiseToi()
		puts "init modele"
		vue.initInterface()
		puts "init interface"
	end


	##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btValiderOptions : le gtkButton qu'il faudra lier � l'action d'un clic sur Valider (dans options)
   #
   def validerOptionsCreer(btValiderOptions, radioButtonOui, radioButtonNon, comboBoxListeLangue,fenetre)
      btValiderOptions.signal_connect('clicked'){
          validerOptionsAction(radioButtonOui, radioButtonNon, comboBoxListeLangue)
        fenetre.destroy()
      }
   end
 
 
	##
	# Action(s) � effectuer lors du clic sur le bouton Valider (dans options)
	#
	def validerOptionsAction(radioButtonOui, radioButtonNon, comboBoxListeLangue)
		puts "Clique sur Valider (dans options)"
		
		if(radioButtonOui.active?)
			Audio.activeSound()
			puts "Son active"
		elsif(radioButtonNon.active?)
			Audio.mute()
			puts "son desactive"
		end

		if(comboBoxListeLangue.active == 0)
			XmlMultilingueReader.setLangue("FR")
			puts "Langue FR"
		elsif(comboBoxListeLangue.active == 1)
			XmlMultilingueReader.setLangue("EN")
			puts "Langue EN"
		end
	
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherMenu()
	end


   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btRetour : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Retour
   #
   def retourCreer(btRetour)
      btRetour.signal_connect('clicked'){
          retourAction()
      }
   end
 
 
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Retour
	#
	def retourAction
		puts "Clique sur Retour"
		@vue.menu.viderFenetre(@vue.menu.contenu)
		puts "Vidage du contenu du menu principal"
		@vue.menu.afficherMenu()
	end
	
	
	##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btQuitter : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Quitter Partie
   #
   def quitterPartieCreer(btQuitter,fenetre)
      btQuitter.signal_connect('clicked'){
          quitterPartieAction()
         fenetre.destroy()
      }
   end
 
 
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Quitter Partie
	#
	def quitterPartieAction
		puts "Clique sur Quitter Partie"
		Gtk.main_quit
	end
  ### Gestion des événements de la fenêtre d'inventaire ###
  
  ##
  # Sélectionne un item lors de l'appuie sur le bouton qui lui correspond dans l'inventaire
  #
  def selectionnerItem(btItem,indiceItem)
  btItem.signal_connect('button_press_event'){
  puts "(S) Sélection de l'item "+indiceItem.to_s+"."
  @vue.inventaireVue.setImageSelection(indiceItem)
  }
  end
  
  ##
  # Achète l'item sélectionné lors de l'appuie sur le bouton "Acheter" dans l'inventaire
  #
  def acheterItem(btAcheter)
  btAcheter.signal_connect('clicked'){
  puts "(S) Achat de l'item "+"XX"+"."
  #@vue.vueInventaire.setImageSelection(indiceItem)
  }
  end
  
  ##
  # Vends l'item sélectionné lors de l'appuie sur le bouton "Vendre" dans l'inventaire
  #
  def vendreItem(btVendre)
  btVendre.signal_connect('clicked'){
  puts "(S) Vente de l'item "+"XX"+"."
  #@vue.vueInventaire.setImageSelection(indiceItem)
  }
  end
  
  ##
  # Jette l'item sélectionné lors de l'appuie sur le bouton "Jeter" dans l'inventaire
  #
  def jeterItem(btJeter)
  btJeter.signal_connect('clicked'){
  puts "(S) Jet de l'item "+"XX"+"."
  #@vue.vueInventaire.setImageSelection(indiceItem)
  }
  end
  
  ##
  # Equipe le joueur de l'item sélectionné lors de l'appuie sur le bouton "Equiper" dans l'inventaire
  #
  def equiperItem(btEquiter)
  btEquiter.signal_connect('clicked'){
  puts "(S) Equipement du joueur avec l'item "+"XX"+"."
  #@vue.vueInventaire.setImageSelection(indiceItem)
  }
  end
      
end
