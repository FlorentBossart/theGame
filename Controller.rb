#!/usr/bin/env ruby

##
# Fichier        : Controller.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente le Controlleur du jeu
#



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
   end
   
   def Controller.creer(modele,vue)
     new(modele,vue)
   end

    
    
     
      ##
      # Constructeur privé : crée un nouveau DeplacementHaut : classe interne pour gérer l'action d'un clic sur le bouton DeplacementHaut
      #
      # == Parameters:
      # btDeplacementHaut : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le haut
      #
  def deplacementHautCreer(btDeplacementHaut)
      btDeplacementHaut.signal_connect('button_press_event'){
        deplacementHautAction();
      }
  end
      

             
       ##
       # Action(s) à effectuer lors du clic sur le bouton DeplacementHaut
       #
  def deplacementHautAction
    print "/\ Bt déplacement haut pressé!"
    if(@modele.tourDejaPasse == false)
      @modele.tourPasse()
    end
    @modele.joueur.deplacement(EnumDirection.NORD)

  end

    
    
  ##
  # Constructeur privé : crée un nouveau DeplacementBas : classe interne pour gérer l'action d'un clic sur le bouton DeplacementBas
  #
  # == Parameters:
  # btDeplacementBas : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le bas
  #
  def deplacementBasCreer(btDeplacementBas)
      btDeplacementBas.signal_connect('button_press_event'){
        deplacementBasAction();
      }
  end
        

        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementHaut
        #
  def deplacementBasAction
    print "\/ Bt déplacement bas pressé!"
    if(@modele.tourDejaPasse == false)
      @modele.tourPasse()
    end
    @modele.joueur.deplacement(EnumDirection.SUD)
  end
 
    
        ##
        # Constructeur privé : crée un nouveau DeplacementGauche : classe interne pour gérer l'action d'un clic sur le bouton DeplacementGauche
        #
        # == Parameters:
        # btDeplacementGauche : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la gauche
        #
  def deplacementGaucheCreer(btDeplacementGauche)
     btDeplacementGauche.signal_connect('button_press_event'){
       deplacementGaucheAction();
     }
  end
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementGauche
        #
  def deplacementGaucheAction
    print "<< Bt déplacement gauche pressé!"
    if(@modele.tourDejaPasse == false)
      @modele.tourPasse()
    end
    @modele.joueur.deplacement(EnumDirection.OUEST)
  end
        

    
  
        
        ##
        # Constructeur privé : crée un nouveau DeplacementDroite : classe interne pour gérer l'action d'un clic sur le bouton DeplacementDroite
        #
        # == Parameters:
        # btDeplacementDroite : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la droite
        #
  def deplacementDroiteCreer(btDeplacementDroite)
      btDeplacementDroite.signal_connect('button_press_event'){
          deplacementDroiteAction();
        }
    end
        
  
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementDroite
        #
  def deplacementDroiteAction
    print ">> Bt déplacement droite pressé!"
    if(@modele.tourDejaPasse == false)
      @modele.tourPasse()
    end
    @modele.joueur.deplacement(EnumDirection.EST)
  end
        

        
        ##
        # Constructeur privé : crée un nouveau Repos : classe interne pour gérer l'action d'un clic sur le bouton repos
        #
        # == Parameters:
        # btRepos : le gtkButton qu'il faudra lier à l'action d'un repos
        #
  def reposCreer(btRepos)
      btRepos.signal_connect('clicked'){
          reposAction();
        }
    end
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton repos
        #
  def reposAction
    print "ZZzzzZZZzzzz Bt repos pressé!"
  end

    
        
        ##
        # Constructeur privé : crée un nouvel Inventaire : classe interne pour gérer l'action d'un clic sur le bouton inventaire
        #
        # == Parameters:
        # btInventaire : le gtkButton qu'il faudra lier à l'action du clic sur le bouton inventaire
        #
  def inventaireCreer(btInventaire)
     btInventaire.signal_connect('clicked'){
        inventaireAction();
      }
  end
        

        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
  def inventaireAction
    print "oO Bt inventaire pressé!"
  end


        ##
        # Constructeur privé : crée un nouveau Menu : classe interne pour gérer l'affichage du menu
        #
        # == Parameters:
        # btMenu : le gtkButton qu'il faudra lier aux actions d'affichage du menu
        #
  def menuCreer(btMenu)
      btMenu.signal_connect('clicked'){
        menuAction();
      }
  end
        
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
  def menuAction
    print "<--> Affichage du menu"
  end

    
        ##
        # Constructeur privé : crée une nouvel Interaction : classe interne pour gérer l'action d'un clic sur le bouton Interaction
        #
        # == Parameters:
        # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
        # vue : reference a la vue a passer aux instances d'InteractionModal
  def interactionCreer(btInteraction)
      btInteraction.signal_connect('clicked'){
        interactionAction();
      }
  end
        
   
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
  def interactionAction()
    print "oO Bt interaction pressé!"
    @vue.interactionModal.new(@modele,@vue)
  end

    

      
      ##
      # Constructeur privé : crée une nouvel Interaction : classe interne pour gérer l'action d'un clic sur le bouton Interaction
      #
      # == Parameters:
      # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
      #
  def interactionElementCreer(btInteraction,elem,joueur)
      btInteraction.signal_connect('clicked'){
        elem.interaction(joueur)
        interactionElementAction(elem)
     }
  end
      
      
      ##
      # Action(s) à effectuer lors du clic sur le bouton inventaire
      #
  def interactionElementAction(elem)
    print "oO Bt interaction "+elem.intitule+" pressé!"
  end
      
  ##
  # equipe un item lors de l'appuie sur le bouton correspondant
  #
  
  def equiperItemCreer(btInteraction,elem,joueur)
      btInteraction.signal_connect('clicked'){
        equiperItemAction(joueur,elem)
     }
  end
      
      
      ##
      # Action(s) à effectuer lors du clic sur le bouton inventaire
      #
  def equiperItemAction(joueur,elem)
    joueur.utiliser(elem)
    print "oO Bt interaction "+elem.intitule+" pressé!"
  end
      
  
  def achatMarchandCreer(btInteraction)
      btInteraction.signal_connect('clicked'){
        achatMarchandAction()
     }
  end
      
      
      ##
      # Action(s) à effectuer lors du clic sur le bouton inventaire
      #
  def achatMarchandAction()
    #a definir
    print "oO Bt interaction "+elem.intitule+" pressé!"
  end
  
  def vendreMarchandCreer(btInteraction)
      btInteraction.signal_connect('clicked'){
        vendreMarchandAction()
     }
  end
      
      
      ##
      # Action(s) à effectuer lors du clic sur le bouton inventaire
      #
  def vendreMarchandAction()
    #a definir
    print "oO Bt interaction "+elem.intitule+" pressé!"
  end
      
  

      
end


