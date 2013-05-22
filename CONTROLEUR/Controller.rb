#!/usr/bin/env ruby

##
# Fichier        : Controller.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe reprÃ©sente le Controlleur du jeu
# 

require 'VUE/Vue.rb'
require 'VUE/Audio.rb'
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
     @vue.zoneCtrl.bloquerBoutons(@modele)
     Thread.new do
       @modele.joueur.deplacement(EnumDirection.NORD)
       
     end
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
     @vue.zoneCtrl.bloquerBoutons(@modele)
    Thread.new do
      @modele.joueur.deplacement(EnumDirection.SUD)

    end
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
     @vue.zoneCtrl.bloquerBoutons(@modele)
    Thread.new do
      @modele.joueur.deplacement(EnumDirection.OUEST)
    end
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
     @vue.zoneCtrl.bloquerBoutons(@modele)
    Thread.new do
      @modele.joueur.deplacement(EnumDirection.EST)
    end
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
    Thread.new do
      @modele.joueur.utiliserRepos() 
      @modele.debutTour()
    end
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
    @vue.window.modal = false #AFR
    @vue.inventaireModal.afficherInventaire(@modele.joueur, EnumStadePartie.INVENTAIRE_USAGE)
    print "oO Bt inventaire pressÃ©!"
  end

  
  ##
  #  Fait le lien entre un bouton et l'action lié au choix Jeter
  #
  # == Parameters:
  # btInventaire : le gtkButton qu'il faudra lier Ã  l'action du clic sur le bouton inventaire
  # dialog: PopUp lie au bouton
  #
 def choixInventairePleinCreer(buttonJeter,dialog)
    buttonJeter.signal_connect('clicked'){
      dialog.destroy
      choixInventairePleinAction(buttonJeter)
     }
 end
       

 ##
 # Action(s) a  effectuer lors du clic sur le bouton Jeter (choix)
 #
 def choixInventairePleinAction(buttonJeter)
   @vue.window.modal = false #AFR
   @vue.inventaireModal.afficherInventaire(@modele.joueur, EnumStadePartie.INVENTAIRE_PLEIN)
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
    if(!@modele.joueur.toujoursEnVie?()) # Si le joueur est mort, cr�ation menu avec moins de bouton
    	@vue.menu = MenuJeu.creer(false, @modele, self)
    #else
    	#@vue.menu = MenuJeu.creer(true, @modele, self)
    end
    puts "-- Affichage du menu"
    @vue.window.modal = false;
    @vue.window.set_sensitive(false)
    @vue.menu.afficherMenu()
    
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
        dialog.destroy
        interactionElementAction(elem,joueur)
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
     Thread.new do
        elem.interaction(joueur)
     end
    @vue.window.modal=true
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
    dialog.destroy
    achatMarchandAction()
    
  }
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
    dialog.destroy
    vendreMarchandAction()
  }
  end
  
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton d'achat
  #
  def achatMarchandAction()
    print "oO Bt achatMarchandAction  pressÃ©!"
    #@modele.joueur.encaisser(10000) #TODO : supprimmer cette ligne
    
    #AFR
    if @modele.joueur.inventaire.estPlein?
        puts "Inventaire plein avant achat"
        @vue.popUp.choixInventairePlein
    else 
       @vue.inventaireModal.afficherInventaire(@modele.pnjAideEnInteraction, EnumStadePartie.INTERACTION_MARCHAND_ACHAT)
    end
  end
  
  
  ##
  # Action(s) Ã  effectuer lors du clic sur le bouton de vente
  #
  def vendreMarchandAction()
    print "oO Bt venndreMarchandAction  pressÃ©!"
    puts "====>>> Affichage de l'inventaire en mode vente" 
    @vue.inventaireModal.afficherInventaire(@modele.joueur, EnumStadePartie.INTERACTION_MARCHAND_VENTE)
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
    dialog.destroy
    soinAction(joueur,choix,guerisseur)

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
    Thread.new do
      guerisseur.guerrir(joueur,choix)
      @vue.window.modal=true
      @modele.debutTour()
    end
  end
      
  
  ##
  # equipe un item lors de l'appuie sur le bouton correspondant
  #
  # == Parameters:
  # joueur : le joueur qui doit equiper l'item
  # elem : element a equiper
  # dialog: popup liÃ© au bouton
  #
  def equiperItemCreer(btInteraction,elem,joueur,dialog,momentCombat)
      btInteraction.signal_connect('clicked'){
        equiperItemAction(joueur,elem,momentCombat)
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
  def equiperItemAction(joueur,elem,momentCombat)
    Thread.new do

      joueur.utiliserItem(elem)

    end
    print "oO Bt interaction "+elem.getIntitule()+" pressÃ©!"
    if(elem.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARMURE)
      @modele.suiteEquipementChoixArme(momentCombat)
    else
      @modele.declencherCombat(momentCombat)
    end
    @vue.window.modal=true
  end
  
  

  
##### Pour le menu  
  
  ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btContinuerPartie : le gtkButton qu'il faudra lier � l'action d'un clic sur Continuer partie
   #
   def continuerPartieCreer(btContinuerPartie,fenetre)
      #btContinuerPartie.signal_connect('clicked'){
      btContinuerPartie.signal_connect('button_press_event'){
          continuerPartieAction()
          fenetre.destroy()
      }
   end
   
          
	##
	# Action(s) à effectuer lors du clic sur le bouton ContinuerPartie
	#
	def continuerPartieAction()
		puts "Clique sur continuer partie"
		#@vue.menu.fenetreMenu.destroy
		#puts "Destruction du menu"
		@vue.window.set_sensitive(true)
	end
  
  
  ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btNewPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur NouvellePartie
   #
   def nouvellePartieCreer(btNewPartie,fenetre)
     # btNewPartie.signal_connect('clicked'){
     btNewPartie.signal_connect('button_press_event'){
          nouvellePartieAction()
        fenetre.destroy()
      }
   end
     
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton NouvellePartie
	#
	def nouvellePartieAction
		puts "Clique sur nouvelle partie"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherNouvellePartie()
	end

      
   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btChargerPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur ChargerPartie
   #
   def chargerPartieCreer(btChargerPartie,fenetre)
      #btChargerPartie.signal_connect('clicked'){
      btChargerPartie.signal_connect('button_press_event'){
          chargerPartieAction()
          fenetre.destroy()
      }
   end  
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton ChargerPartie
	#
	def chargerPartieAction
		puts "Clique sur charger partie"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherChargerPartie()
	end

   
   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btSauvegarderPartie : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur SauvegarderPartie
   #
   def sauvegarderPartieCreer(btSauvegarderPartie,fenetre)
     # btSauvegarderPartie.signal_connect('clicked'){
      btSauvegarderPartie.signal_connect('button_press_event'){
          sauvegarderPartieAction()
        fenetre.destroy()
      }
   end
 
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton SauvegarderPartie
	#
	def sauvegarderPartieAction
		puts "Clique sur sauvegarder partie"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherSauvegarderPartie()
	end



   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btClassement : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Classement
   #
   def classementCreer(btClassement,fenetre)
     # btClassement.signal_connect('clicked'){
     btClassement.signal_connect('button_press_event'){
          classementAction()
        fenetre.destroy()
      }
   end
   
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Classement
	#
	def classementAction
		puts "Clique sur classement"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherClassement()
	end


   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btOptions : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Options
   #
   def optionsCreer(btOptions,fenetre)
     # btOptions.signal_connect('clicked'){
     btOptions.signal_connect('button_press_event'){
          optionsAction()
        fenetre.destroy()
      }
   end
 
  
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Options
	#
	def optionsAction
		puts "Clique sur options"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherOptions()
	end

   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btAide : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Aide
   #
   def aideCreer(btAide,fenetre)
      #btAide.signal_connect('clicked'){
      btAide.signal_connect('button_press_event'){
          aideAction()
          fenetre.destroy()
      }
   end
    
          
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Aide
	#
	def aideAction
		puts "Clique sur aide"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
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
      }
      entryPseudo.signal_connect('activate'){
			commencerNewPartieAction(entryPseudo.text, boutRadioNovice, boutRadioMoyen, boutRadioExpert, fenetre)
		}
   end
 
 
	##
	# Action(s) a effectuer lors du clic sur le bouton "C'est Parti" dans nouvelle partie
	#
	def commencerNewPartieAction(pseudo, boutRadioNovice, boutRadioMoyen, boutRadioExpert, fenetre)
		puts "Clique sur C'est Parti"
		if(pseudo == "")
			pseudo = "JoueurInconnu"
		end
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
		
		#@vue.menu.fenetreMenu.destroy
		
		
		if(@vue.menu.isInGame == true || @modele.joueur.toujoursEnVie? == false)
			@vue.window.destroy
			puts "Destroy partie"
		end
		
		fenetre.destroy
		
		quitterPartieAction()
	
		# Creation de la vue
		vue=Vue.creer()
		
		# Creation du modele
		modele = Modele.creer(vue,difficulte,pseudo)
		
		
		
		puts "modele creer"
		puts "difficulte : " + difficulte.to_s
		controller=Controller.creer(modele,vue)
		puts "controller creer"
		vue.defM(modele)
		vue.defC(controller)
		puts "vue defc"
		modele.initialiseToi() # Debut du temps � la cr�ation d'un joueur
		
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
   def validerOptionsCreer(btValiderOptions, radioButtonOui, radioButtonNon, radioBO2, radioBN2, comboBoxListeLangue, fenetre)
         btValiderOptions.signal_connect('clicked'){
             validerOptionsAction(radioButtonOui, radioButtonNon, radioBO2, radioBN2, comboBoxListeLangue)
             fenetre.destroy()
         }
   end
 
 
	##
	# Action(s) � effectuer lors du clic sur le bouton Valider (dans options)
	#
   def validerOptionsAction(radioButtonOui, radioButtonNon, radioBO2, radioBN2, comboBoxListeLangue)
		puts "Clique sur Valider (dans options)"
		
		if(radioButtonOui.active?)
			Audio.resumeSoundLoop()
			puts "Son active"
		elsif(radioButtonNon.active?)
			Audio.muteSoundLoop()
			puts "son desactive"
		end
		
      if(radioBO2.active?)
        Audio.resumeBruitage()
        puts "Son des bruitages active"
      elsif(radioBN2.active?)
        Audio.muteBruitage()
        puts "Son des bruitages desactive"
      end

		if(comboBoxListeLangue.active == 0)
			XmlMultilingueReader.setLangue("FR")
			puts "Langue FR"
		elsif(comboBoxListeLangue.active == 1)
			XmlMultilingueReader.setLangue("EN")
			puts "Langue EN"
		end
		
		if(@vue.menu.isInGame == true)
			@vue.majLangue()
		end
	
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherMenu()
	end


   ##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btRetour : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Retour
   #
   def retourCreer(btRetour,fenetre)
      btRetour.signal_connect('clicked'){
          fenetre.destroy()
          retourAction()
      }
   end
 
 
	##
	# Action(s) ï¿½ effectuer lors du clic sur le bouton Retour
	#
	def retourAction
		puts "Clique sur Retour"
		#@vue.menu.viderFenetre(@vue.menu.contenu)
		#puts "Vidage du contenu du menu principal"
		@vue.menu.afficherMenu()
	end
	
	
	##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # btQuitter : le gtkButton qu'il faudra lier ï¿½ l'action d'un clic sur Quitter Partie
   #
   def quitterPartieCreer(btQuitter,fenetre)
      #btQuitter.signal_connect('clicked'){
      btQuitter.signal_connect('button_press_event'){
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
	
	
	##
   # Liaison de l'action sur le bouton
   #
   # == Parameters:
   # fenetre : la gtk::Window qu'il faudra lier a l'action d'un clic sur la croix de fermeture (croix rouge sous windows)
   #
   def destroyMenuCreer(fenetre)
      fenetre.signal_connect('delete_event'){
          destroyMenuAction(fenetre)
      }
   end
 
 
	##
	# Action(s) ï¿½ effectuer lors du clic sur la croix de fermeture (croix rouge sous windows)
	#
	def destroyMenuAction(fenetre)
		puts "Fermeture du menu par la croix rouge !"
		if(@vue.menu.isInGame == true)
			@modele.vue.window.set_sensitive(true)
		else
			Gtk.main_quit
		end
		fenetre.destroy
	end
	

### Gestion des événements de la fenêtre d'inventaire ###
 
	##
	# Sélectionne un item lors de l'appuie sur le bouton qui lui correspond dans l'inventaire
	#
	def selectionnerItem(btItem,indiceItem)
		btItem.signal_connect('button_press_event'){
			puts "(S) Sélection de l'item "+indiceItem.to_s+"."
			@vue.inventaireModal.setImageSelection(indiceItem)
			@vue.inventaireModal.setBoutonInteractionActif(true)
			@modele.indiceItemSelectionne = indiceItem
		}
	end
	
	##
	# Achète l'item sélectionné lors de l'appuie sur le bouton "Acheter" dans l'inventaire
	#
	def acheterItem(btAcheter)
	  btAcheter.signal_connect('clicked'){
	  puts "(S) Achat de l'item "+"XX"+"."
	  Thread.new do
      marchand = @modele.pnjAideEnInteraction
	  #Le marchand vend l'item sélectionné par le joueur à ce dernier
	 # marchand.vendre(@modele.joueur, marchand.listeItem.itemsStock[@modele.indiceItemSelectionne])
	  	  marchand.vendre(@modele.joueur, @vue.inventaireModal.inventaireCourant[@modele.indiceItemSelectionne])
	  @vue.inventaireModal.onDestroy()
      @vue.window.modal=true
      @modele.debutTour()
      
	  end
		}
	end
	
	##
	# Vends l'item sélectionné lors de l'appuie sur le bouton "Vendre" dans l'inventaire
	#
	def vendreItem(btVendre)
		btVendre.signal_connect('clicked'){
			puts "(S) Vente de l'item " + @modele.indiceItemSelectionne.to_s + "."
			Thread.new do
  			#@modele.joueur.encaisser(  @modele.joueur.inventaire.prix( @modele.indiceItemSelectionne))
  			#@modele.joueur.retirerDuStock(@modele.indiceItemSelectionne)
  			@modele.joueur.vendre(@modele.indiceItemSelectionne)
  			@vue.inventaireModal.onDestroy()
        @vue.window.modal=true
  			@modele.debutTour()
  			#@vue.vueInventaire.setImageSelection(indiceItem)
			end
		}
	end
	
	##
	# Jette l'item sélectionné lors de l'appuie sur le bouton "Jeter" dans l'inventaire
	#
	def jeterItem(btJeter)
		btJeter.signal_connect('clicked'){
			Thread.new do 
			  puts "(S) Jet de l'item " +@modele.joueur.inventaire.getItem(@modele.indiceItemSelectionne).to_s + "."
  			@modele.joueur.retirerDuStock(@modele.joueur.inventaire.getItem(@modele.indiceItemSelectionne))
  			@vue.inventaireModal.onDestroy
        @vue.window.modal=true
  			@vue.actualiser
			end
		}
	end
	
	
    ##
	# Utiliser l'item sélectionné au profit du joueur lors de l'appuie sur le bouton "Utiliser" dans l'inventaire
	#
	def utiliserItem(btUtiliser)
		btUtiliser.signal_connect('clicked'){
			puts "(U) Utilisation de l'item "+ @modele.indiceItemSelectionne.to_s + "."
            Thread.new do 
  			   @modele.joueur.utiliserItem(@modele.joueur.inventaire.getItem(@modele.indiceItemSelectionne))
  			   @vue.actualiser()
           @vue.window.modal=true
  			   @vue.inventaireModal.onDestroy
            end
		}
	end
end
