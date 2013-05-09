#!/usr/bin/env ruby
#truc
##
# Fichier        : Modele.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente le modèle du jeu défini par :
# == Une difficulté
# == Une carte
# == Un joueur
# == Une liste des ennemis présents dans le jeu et qui évoluent à chaque tour
# == un compteur de tour de jeu
#


require './AffichageDebug.rb'
require './Enum/EnumStadePartie.rb'
require './Joueur.rb'
require './Inventaire.rb'
require './Guerisseur.rb'
require './Marchand.rb'
require './Pisteur.rb'
require './EnnemiNormal.rb'
require './Caracteristique.rb'
require './Encaissable.rb'
require './Mangeable.rb'
require './Equipable.rb'
require './Type/TypeEnnemi.rb'
require './Type/TypeEquipable.rb'
require './Type/TypeMangeable.rb'
require './Type/TypeTerrain.rb'
require './Type/Difficulte.rb'
require './Bibliotheque/BibliothequeTypeEnnemi.rb'
require './Bibliotheque/BibliothequeTypeEquipable.rb'
require './Bibliotheque/BibliothequeTypeMangeable.rb'
require './Bibliotheque/BibliothequeTypeTerrain.rb'
require './Bibliotheque/BibliothequeDifficulte.rb'
require './XMLReader/XmlDifficultesReader.rb'
require './XMLReader/XmlEnnemisReader.rb'
require './XMLReader/XmlEquipablesReader.rb'
require './XMLReader/XmlMangeablesReader.rb'
require './XMLReader/XmlTerrainsReader.rb'

class Modele

   @vue
   @listeEnnemis
   @compteurTour
   @difficulte
   @carte
   @joueur
   @pseudoPartie
   @stadePartie
   @notifications
   @messageDefaite
   @itemAttenteAjout
   @pnjAideEnInteraction
   @tourDejaPasse

   private_class_method :new

   attr_reader :difficulte, :carte, :joueur, :listeEnnemis, :stadePartie, :messageDefaite
   attr_accessor :compteurTour, :itemAttenteAjout, :pnjAideEnInteraction, :tourDejaPasse, :notifications
   
   
   def Modele.initialisationBibliotheques()
     XmlDifficultesReader.lireXml()
     XmlEnnemisReader.lireXml()
     XmlEquipablesReader.lireXml()
     XmlMangeablesReader.lireXml()
     XmlTerrainsReader.lireXml() 
   end
   
   
   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>vue :</b> la vue du jeu
   #
   def Modele.creer(vue,difficulte,pseudo)
      return new(vue,difficulte,pseudo)
   end
   

   ##
   # Crée un nouveau model à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>vue :</b> la vue du jeu
   #* <b>difficulte :</b> la difficulte de la partie
   #* <b>pseudo :</b> le pseudo du joueur pour cette partie
   #
   def initialize(vue,difficulte,pseudo)
      @vue = vue
      @difficulte=difficulte
      @pseudoPartie=pseudo
   end
     
   def initialiseToi()
     
      @compteurTour = 0
      @tourDejaPasse=false
     
      @notifications=Array.new()
      @notifications.push("Debut de partie")
      
      # Creation de la carte
      @carte = Carte.nouvelle(@difficulte.longueurCarte, @difficulte.largeurCarte)

      # Initialisation de la case du joueur
      pasTrouver = true
      while(pasTrouver)
         larg_cj = rand(@carte.largeur-1)
         long_cj = rand(@carte.longueur-1)
         caseJoueur = @carte.getCaseAt(larg_cj, long_cj)
         if(caseJoueur.typeTerrain.isAccessible)
            pasTrouver = false
         end
      end
      
      # Creation du joueur
      @joueur = Joueur.creer(@difficulte.nbRepos, @difficulte.energieDepart, 100, Inventaire.creer(12), self, caseJoueur, @pseudoPartie)
      caseJoueur.joueur = @joueur # Attribution du joueur à la case
           
      # Creation des PNJ Amis de depart
      for i in 0..@difficulte.pnjAmisDepart-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1, rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type de PNJ Ami
         choix = rand(2)-1 # Nb aleatoire -1 ou 0
         if(choix == 0)
            element = Marchand.creer(caseAleatoire)
         else
            element = Guerisseur.creer(caseAleatoire)
         end

         # Ajout du PNJ Ami dans la case aleatoire
         caseAleatoire.ajouterElement(element)
      end
      
      # Creation des PNJ ennemis de depart
      @listeEnnemis = Array.new()
      for i in 0 .. @difficulte.pnjEnnemisDepart-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1, rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type de PNJ Ennemi
         choix = rand(2)-1 #Nb aleatoire -1 ou 0
         if(choix == 0)
            ennemi = EnnemiNormal.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard())
         else
            ennemi = Pisteur.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard(), @joueur)
         end

         # Ajout du PNJ Ennemi dans la case aleatoire et dans la listeEnnemis
         caseAleatoire.ajouterEnnemi(ennemi)
         @listeEnnemis.push(ennemi)
      end
      
      # Creation des items disséminer sur la carte
      for i in 0 .. @difficulte.objetsDepart-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1,rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type d'item
         choix = rand(3)-1 #Nb aleatoire -1, 0 ou 1
         if(choix == 0)
            caracteristique = Mangeable.creer(BibliothequeTypeMangeable.getTypeMangeableAuHasard())
         elsif(choix == 1)
            caracteristique = Equipable.creer(BibliothequeTypeEquipable.getTypeEquipableAuHasard())
         else
            montant = rand(1000)+1
            caracteristique = Encaissable.creer(montant)
         end

         element = Item.creer(caseAleatoire, caracteristique)
         
        # Ajout de l'item dans la case aleatoire       
        caseAleatoire.ajouterElement(element)
      end
     
     #PAS D'ACTUALISATION CAR MODELE SE CREER AVANT LA VUE  
     #changerStadePartie(EnumStadePartie.ETAPE_FINIE)
   end

   def changerStadePartie(nouveauStade)
     @stadePartie=nouveauStade
     AffichageDebug.Afficher("Stade Partie=#{nouveauStade}")
     #METHODE VUE
     @vue.actualiser()
     @stadePartie=EnumStadePartie.ETAPE_FINIE
     AffichageDebug.Afficher("Stade Partie Terminé")
   end
   
   def notifier(notification)
       @notifications.push(notification)
   end

   def lireNotification()
     return @notifications.shift
   end

   ##
   # Permet d'ajouter des ennemis au jeu.
   #
   def ajoutEnnemis()
      for i in 0..@difficulte.pnjEnnemisParGeneration-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1, rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type de PNJ Ennemi
         choix = rand(2)-1 #Nb aleatoire -1 ou 0
         if(choix == 0)
            ennemi = EnnemiNormal.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard())
         else
            ennemi = Pisteur.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard(), @joueur)
         end

         # Ajout du PNJ Ennemi dans la case aleatoire et dans la listeEnnemis
         caseAleatoire.ajouterEnnemi(ennemi)
         @listeEnnemis.push(ennemi)
      end
   end

   
   ##
   # Permet d'ajouter des items au jeu.
   #
   def ajoutItems()
      for i in 0 .. @difficulte.objetsParGeneration-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1,rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type d'item
         choix = rand(3)-1 #Nb aleatoire -1, 0 ou 1
         if(choix == 0)
            caracteristique = Mangeable.creer(BibliothequeTypeMangeable.getTypeMangeableAuHasard())
         elsif(choix == 1)
            caracteristique = Equipable.creer(BibliothequeTypeEquipable.getTypeEquipableAuHasard())
         else
            montant = rand(1000)+1
            caracteristique = Encaissable.creer(montant)
         end
         element = Item.creer(caseAleatoire, caracteristique)
         caseAleatoire.ajouterElement(element)
      end
   end

   
   ##
   # Permet d'eliminer un ennemi du jeu.
   #
   # == Parameters:
   #* <b>ennemi :</b> l'ennemi à eliminer
   #
   def eliminerEnnemi(ennemi)
      @listeEnnemis.delete(ennemi)
      ennemi.casePosition.retirerEnnemi(ennemi)
   end

     
#METHODE POUR GERER LES ACTION DU JOUEUR ETAPES APRES ETAPES
   
   ##
   # Permet de faire passer un tour. 
   # 
   def tourPasse()
     notifier("Un tour passe")
      @tourDejaPasse=true
      @compteurTour += 1
      # Deplacement des ennemis
      for e in @listeEnnemis
         e.deplacementIntelligent()
      end
      
      # Ajout d'ennemis
      if(@compteurTour % @difficulte.nbToursInterGenerations == 0)
         ajoutEnnemis()
      end
   end

   ##
   # Permet de lancer un tour: 
   # le joueur est sur une case
   # il faut attaquer les ennemis deja present si il y en a
   #
   def debutTour()
     if(!@joueur.toujoursEnVie?())
       @messageDefaite=@joueur.causeMort
       changerStadePartie(EnumStadePartie.PERDU)
     else
        if(@joueur.casePosition.presenceEnnemis?() && @joueur.peutSEquiper)
            choixEquipementAvantCombat()
        elsif(@joueur.casePosition.presenceEnnemis?() && !@joueur.peutSEquiper)
            declencherCombat()
        else
            choixLibre()
        end
     end
   end
  
  ##
  # Permet au joueur de s'equiper
  #
  def choixEquipementAvantCombat()
     #on commence par les armures
     compteurArmures=0
     
     if(!@joueur.armureEquip?())
       for i in @joueur.inventaire.items
         if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARMURE)
            compteurArmures+=1
         end
       end
      
       AffichageDebug.Afficher("compteurArmures=#{compteurArmures}")
       if(compteurArmures!=0)
          changerStadePartie(EnumStadePartie.EQUIPEMENT_ARMURE)            
       end
     end
     suiteEquipementChoixArme()
  end

  
  ##
  # Permet au joueur de choisir son arme
  #
  def suiteEquipementChoixArme()

    compteurArmes=0
    
    if(!@joueur.armeEquip?())
      for i in @joueur.inventaire.items
        if(i.estEquipable?() && i.caracteristique.typeEquipable.sePorteSur == EnumEmplacementEquipement.ARME)
           compteurArmes+=1
        end
      end
      
      AffichageDebug.Afficher("compteurArmes=#{compteurArmes}")
      if(compteurArmes != 0)
          changerStadePartie(EnumStadePartie.EQUIPEMENT_ARME)      
      end
    end
    declencherCombat()
  end


  ##
  # Permet de declencher le/les combat(s)
  #
  def declencherCombat()
     itemsEnnemis = Array.new()
     
     for ennemi in @joueur.casePosition.listeEnnemis
       itemsUnEnnemi = Array.new() 
       itemsUnEnnemi += @joueur.combattreEnnemi(ennemi)
       
       if(@joueur.toujoursEnVie?())
         itemsEnnemis += itemsUnEnnemi 
       else
         @messageDefaite=@joueur.causeMort+" "+"->lors du combat avec "+ennemi.getIntitule()
         changerStadePartie(EnumStadePartie.PARTIE_PERDU) 
         break
       end
     end
     
     if(@joueur.toujoursEnVie?())
      # Recuperation des items gagnés du/des combat(s)
      for i in itemsEnnemis
        if(@joueur.inventaire.estPlein?())
          @itemAttenteAjout
          changerStadePartie(EnumStadePartie.INVENTAIRE_PLEIN)
        else
          @joueur.inventaire.ajouter(i) 
          notifier("Vous avez récupérez #{i.getIntitule} lors du dernier combat")
        end
      end
      @joueur.peutSEquiper=true
      choixLibre()
    end
    
  end
 
   ##
   # Une fois le combat fini
   #
   def choixLibre()
     changerStadePartie(EnumStadePartie.CHOIX_LIBRE)
     AffichageDebug.Afficher("Fin de 'choixLibre'")
   end
   
=begin
   def lancerPartie()
     while(@joueur.toujoursEnVie?())
       debutTour()
     end
   end
=end
#si lancé dans le modele, la vue n'aura pas la main donc ça devra être lançé dans controleur
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Modele sur lequel la méthode est appellée.
   #
   def to_s
      return "[MODELE]"
   end

end
