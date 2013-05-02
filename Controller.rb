#!/usr/bin/env ruby

##
# Fichier        : Controller.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente le Controlleur du jeu
#

require 'Vue.rb'


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
      @vue    = vue;
   end

    
    
    

   ## 
   # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton DeplacementHaut
   # 
   class DeplacementHaut
       
      private_class_method :new
      
      ##
      # Constructeur privé : crée un nouveau DeplacementHaut : classe interne pour gérer l'action d'un clic sur le bouton DeplacementHaut
      #
      # == Parameters:
      # btDeplacementHaut : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le haut
      #
      def initialize(btDeplacementHaut)
         btDeplacementHaut.signal_connect('button_press_event'){
             action();
         }
      end
    
      ##
      # Crée un nouveau DeplacementHaut : classe interne pour gérer l'action d'un clic sur le bouton DeplacementHaut
      #
      # == Parameters:
      # btDeplacementHaut : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le haut
      #
      def DeplacementHaut.creer(btDeplacementHaut)
         new(btDeplacementHaut)    
      end    
             
       ##
       # Action(s) à effectuer lors du clic sur le bouton DeplacementHaut
       #
      def action
          print "/\ Bt déplacement haut pressé!"
      end

   end
    
    

    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton DeplacementHaut
    # 
    class DeplacementBas
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouveau DeplacementBas : classe interne pour gérer l'action d'un clic sur le bouton DeplacementBas
        #
        # == Parameters:
        # btDeplacementBas : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le bas
        #
        def initialize(btDeplacementBas)
            btDeplacementBas.signal_connect('button_press_event'){
                action();
            }
        end
        
        ##
        # Crée un nouveau DeplacementBas : classe interne pour gérer l'action d'un clic sur le bouton DeplacementBas
        #
        # == Parameters:
        # btDeplacementBas : le gtkButton qu'il faudra lier à l'action d'un déplacement vers le bas
        #
        def DeplacementBas.creer(btDeplacementBas)
            new(btDeplacementBas)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementHaut
        #
        def action
            print "\/ Bt déplacement bas pressé!"
        end
        
    end
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton DeplacementGauche
    # 
    class DeplacementGauche
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouveau DeplacementGauche : classe interne pour gérer l'action d'un clic sur le bouton DeplacementGauche
        #
        # == Parameters:
        # btDeplacementGauche : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la gauche
        #
        def initialize(btDeplacementGauche)
            btDeplacementGauche.signal_connect('button_press_event'){
                action();
            }
        end
        
        ##
        # Crée un nouveau DeplacementGauche : classe interne pour gérer l'action d'un clic sur le bouton DeplacementGauche
        #
        # == Parameters:
        # btDeplacementGauche : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la gauche
        #
        def DeplacementGauche.creer(btDeplacementGauche)
            new(btDeplacementGauche)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementGauche
        #
        def action
            print "<< Bt déplacement gauche pressé!"
        end
        
    end
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton DeplacementDroite
    # 
    class DeplacementDroite
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouveau DeplacementDroite : classe interne pour gérer l'action d'un clic sur le bouton DeplacementDroite
        #
        # == Parameters:
        # btDeplacementDroite : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la droite
        #
        def initialize(btDeplacementDroite)
            btDeplacementDroite.signal_connect('button_press_event'){
                action();
            }
        end
        
        ##
        # Crée un nouveau DeplacementDroite : classe interne pour gérer l'action d'un clic sur le bouton DeplacementDroite
        #
        # == Parameters:
        # btDeplacementDroite : le gtkButton qu'il faudra lier à l'action d'un déplacement vers la droite
        #
        def DeplacementDroite.creer(btDeplacementDroite)
            new(btDeplacementDroite)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton DeplacementDroite
        #
        def action
            print ">> Bt déplacement droite pressé!"
        end
        
    end
    
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton repos
    # 
    class Repos
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouveau Repos : classe interne pour gérer l'action d'un clic sur le bouton repos
        #
        # == Parameters:
        # btRepos : le gtkButton qu'il faudra lier à l'action d'un repos
        #
        def initialize(btRepos)
            btRepos.signal_connect('clicked'){
                action();
            }
        end
        
        ##
        # Crée un nouveau Repos : classe interne pour gérer l'action d'un clic sur le bouton repos
        #
        # == Parameters:
        # btRepos : le gtkButton qu'il faudra lier à l'action du clic sur le bouton repos
        #
        def Repos.creer(btDeplacementDroite)
            new(btDeplacementDroite)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton repos
        #
        def action
            print "ZZzzzZZZzzzz Bt repos pressé!"
        end
        
    end
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton inventaire
    # 
    class Inventaire
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouvel Inventaire : classe interne pour gérer l'action d'un clic sur le bouton inventaire
        #
        # == Parameters:
        # btInventaire : le gtkButton qu'il faudra lier à l'action du clic sur le bouton inventaire
        #
        def initialize(btInventaire,vue)
            btInventaire.signal_connect('clicked'){
                action();
            }
        end
        
        ##
        # Crée un nouvel Inventaire : classe interne pour gérer l'action d'un clic sur le bouton inventaire
        #
        # == Parameters:
        # btInventaire : le gtkButton qu'il faudra lier à l'action du clic sur le bouton inventaire
        #
        def Inventaire.creer(btInventaire,vue)
            new(btInventaire,vue)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
        def action
            print "oO Bt inventaire pressé!"
        end
        
    end
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer pour l'affichage du menu
    # 
    class Menu
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée un nouveau Menu : classe interne pour gérer l'affichage du menu
        #
        # == Parameters:
        # btMenu : le gtkButton qu'il faudra lier aux actions d'affichage du menu
        #
        def initialize(btMenu)
            btMenu.signal_connect('clicked'){
                action();
            }
        end
        
        ##
        # Crée un nouvel Inventaire : classe interne pour gérer l'action d'un clic sur le bouton inventaire
        #
        # == Parameters:
        # btInventaire : le gtkButton qu'il faudra lier à l'action du clic sur le bouton inventaire
        #
        def Menu.creer(btMenu)
            new(btMenu)    
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
        def action
            print "<--> Affichage du menu"
        end
        
    end
    
    
    ## 
    # Classe interne pour définir l'(es) action(s) à effectuer lors d'un clic sur le bouton interaction
    # 
    class Interaction
        
        private_class_method :new
        
        ##
        # Constructeur privé : crée une nouvel Interaction : classe interne pour gérer l'action d'un clic sur le bouton Interaction
        #
        # == Parameters:
        # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
        # vue : reference a la vue a passer aux instances d'InteractionModal
        def initialize(btInteraction,vue)
            btInteraction.signal_connect('clicked'){
                action(vue);
            }
        end
        
        ##
        # Crée un nouvel Interaction : classe interne pour gérer l'action d'un clic sur le bouton inventaire
        #
        # == Parameters:
        # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
        #
        def Interaction.creer(btInteraction,vue)
          new(btInteraction,vue)
        end    
        
        ##
        # Action(s) à effectuer lors du clic sur le bouton inventaire
        #
        def action(vue)
            print "oO Bt interaction pressé!"
            InteractionModal.new(vue)
        end
        
    end
    
  class InteractionElement
      
      private_class_method :new
      
      ##
      # Constructeur privé : crée une nouvel Interaction : classe interne pour gérer l'action d'un clic sur le bouton Interaction
      #
      # == Parameters:
      # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
      #
      def initialize(btInteraction,elem,joueur)
          btInteraction.signal_connect('clicked'){
              elem.interaction(joueur)
              action(elem)
          }
      end
      
      ##
      # Crée un nouveau bouton d'interaction a un element: classe interne pour gérer l'action d'un clic sur le bouton inventaire
      #
      # == Parameters:
      # btInteraction : le gtkButton qu'il faudra lier à l'action du clic sur le bouton interaction
      # elem : l'element avec lequel on souhaite interagir
      #
      def InteractionElement.creer(btInteraction,elem,joueur)
        new(btInteraction,elem,joueur)
      end    
      
      ##
      # Action(s) à effectuer lors du clic sur le bouton inventaire
      #
      def action(elem)
          print "oO Bt interaction "+elem.intitule+" pressé!"
      end
      
  end

end

v = Vue.new()
c = Controller.new("pasencorecréé", v)
