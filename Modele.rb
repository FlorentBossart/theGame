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
require "./Enum/EnumMomentCombat.rb"
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
require './StockMarchand.rb'


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
   @id_terrainParDefaut
   @nbMaxPisteur
   @nbPisteur
   @indiceItemSelectionne 
   
   private_class_method :new

   attr_reader :difficulte, :carte, :joueur, :listeEnnemis, :stadePartie, :messageDefaite, :vue, :id_terrainParDefaut
   attr_accessor :compteurTour, :itemAttenteAjout, :pnjAideEnInteraction, :tourDejaPasse, :notifications, :nbPisteur, :indiceItemSelectionne
   
   
   def Modele.initialisationBibliotheques()
     XmlDifficultesReader.lireXml()
     XmlEnnemisReader.lireXml()
     XmlEquipablesReader.lireXml()
     XmlMangeablesReader.lireXml()
     XmlTerrainsReader.lireXml() 
     XmlMultilingueReader.lireXml()
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
     
      @nbPisteur=0 
      @nbMaxPisteur=10
      @compteurTour = 0
      @tourDejaPasse=false
     
      @notifications=Array.new()
      @notifications.push("Debut de partie")
      
      # Creation de la carte
      @id_terrainParDefaut="plaine" 
      @carte = Carte.nouvelle(@difficulte.longueurCarte, @difficulte.largeurCarte, @id_terrainParDefaut)

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
      stockItemsJeu=StockMarchand.creer()
      for i in 0..@difficulte.pnjAmisDepart-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1, rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

         # Choix du type de PNJ Ami
         choix = rand(2)-1 # Nb aleatoire -1 ou 0
         if(choix == 0)
            element = Marchand.creer(caseAleatoire,stockItemsJeu)
         else
            element = Guerisseur.creer(caseAleatoire)
         end

         # Ajout du PNJ Ami dans la case aleatoire
         caseAleatoire.ajouterElement(element)
      end
      
       @listeEnnemis = Array.new()
      # Creation des PNJ ennemis de depart
      ajoutEnnemis(@difficulte.pnjEnnemisDepart)
      
      # Creation des items disséminer sur la carte
      ajoutItems(@difficulte.objetsDepart)
     
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
   def ajoutEnnemis(nombre)
      for i in 0..nombre-1
         # Recuperation d'une case aleatoire
         begin
            caseAleatoire = @carte.getCaseAt(rand(@carte.longueur)-1, rand(@carte.largeur)-1)
         end while(!(caseAleatoire.typeTerrain.isAccessible && !caseAleatoire.isFull?()))

        if(@nbPisteur<@nbMaxPisteur)
             # Choix du type de PNJ Ennemi
             choix = rand(2)-1 #Nb aleatoire -1 ou 0
             if(choix == 0)
                ennemi = EnnemiNormal.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard(),self)
             else
                ennemi = Pisteur.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard(),self, @joueur)
                @nbPisteur=@nbPisteur+1
             end
        else
             ennemi = EnnemiNormal.creer(caseAleatoire, @joueur.niveau, BibliothequeTypeEnnemi.getTypeEnnemiAuHasard(),self)
        end

         # Ajout du PNJ Ennemi dans la case aleatoire et dans la listeEnnemis
         caseAleatoire.ajouterEnnemi(ennemi)
         @listeEnnemis.push(ennemi)
      end
   end

   
   ##
   # Permet d'ajouter des items au jeu.
   #
   def ajoutItems(nombre)
      for i in 0 .. nombre-1
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
            montant = rand(50)+1
            caracteristique = Encaissable.creer(montant)
         end
         element = Item.creer(caseAleatoire, caracteristique)
         caseAleatoire.ajouterElement(element)
      end
   end

     
#METHODE POUR GERER LES ACTION DU JOUEUR ETAPES APRES ETAPES
   @@pileExecution = Array.new()
   ##
   # Permet de faire passer un tour. 
   # 
   def tourPasse()
     notifier(XmlMultilingueReader.lireTexte("tourPasse"))
      @tourDejaPasse=true
      @compteurTour += 1
      
=begin
     
      Thread.new do
      # Deplacement des ennemis   
		  for e in @listeEnnemis
			if(e.vivant && e.casePosition.coordonneeX>joueur.casePosition.coordonneeX-@vue.largeurAfficheCarte*2 && e.casePosition.coordonneeX<joueur.casePosition.coordonneeX+@vue.largeurAfficheCarte*2 && e.casePosition.coordonneeY>joueur.casePosition.coordonneeY-@vue.hauteurAfficheCarte*2 && e.casePosition.coordonneeY<joueur.casePosition.coordonneeY+@vue.hauteurAfficheCarte*2)
				e.deplacementIntelligent()
				@@pileExecution.delete(e)
			elsif(e.vivant)
				@@pileExecution.unshift(e)
			else
				@listeEnnemis.delete(e)
				@@pileExecution.delete(e)
			end
    end
  end
  
=end
      
      #SANS THREAD
     for e in @listeEnnemis
        e.deplacementIntelligent()   
     end
      
      # Ajout d'ennemis
      if(@compteurTour % @difficulte.nbToursInterGenerations == 0)
         ajoutEnnemis(@difficulte.pnjEnnemisParGeneration)
         ajoutItems(@difficulte.objetsParGeneration)
      end
   end
   
=begin
   
   def enverDuDecors
		Thread.new do
			while true
				if !@@pileExecution.empty?
					element=@@pileExecution.pop
					element.deplacementIntelligent
				else
					sleep 0.01
				end
			end
		end
   end
   
=end

   ##
   # Permet de lancer un tour: 
   # le joueur est sur une case
   # il faut attaquer les ennemis deja present si il y en a
   #
   def debutTour()
     puts "debut debutTour"
     if(!@joueur.toujoursEnVie?())
     	puts "!!!!!!!! Vous etes MORT !!!!!!!"
       @messageDefaite=@joueur.causeMort
       changerStadePartie(EnumStadePartie.PERDU)
       @vue.popUp.affichePopUpMort(@messageDefaite) 
     else
        if(@joueur.casePosition.presenceEnnemis?())
            if(@tourDejaPasse)
              preparationHostilites(EnumMomentCombat.APRES_ACTION)
            else
              preparationHostilites(EnumMomentCombat.APRES_DEPLACEMENT)
            end
        end
        if(@joueur.toujoursEnVie?())
            choixLibre()
        end
     end
     puts "fin debutTour\n"
   end
  
   def preparationHostilites(momentCombat)
     @vue.combatModal.majCombatModal(momentCombat)
     if(@joueur.peutSEquiper)
         choixEquipementAvantCombat()
     elsif(@joueur.casePosition.presenceEnnemis?() && !@joueur.peutSEquiper)
         declencherCombat()
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
          @vue.actualiser()          
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
          @vue.actualiser
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
         changerStadePartie(EnumStadePartie.PERDU) 
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
          if(i.estStockable?())
              @joueur.inventaire.ajouter(i) 
           else
              i.caracteristique.utiliseToi(joueur)
           end
 
          str=XmlMultilingueReader.lireTexte("recupCombat")
          str=str.gsub("ITEM",XmlMultilingueReader.lireDeterminant_Nom(i))
          notifier(str)
        end
      end
      @joueur.peutSEquiper=true
    end
    
  end
 
   ##
   # Une fois le combat fini
   #
   def choixLibre()
     changerStadePartie(EnumStadePartie.CHOIX_LIBRE)
     AffichageDebug.Afficher("Fin de 'choixLibre'")
   end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Modele sur lequel la méthode est appellée.
   #
   def to_s
      return "[MODELE] : ListeEnnemis = #{@listeEnnemis}\n *****Joueur #{@joueur}"
   end

end
