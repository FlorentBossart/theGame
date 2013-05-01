##
# Fichier        : Joueur.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# -test de la classe
#
# Remarques:
#
#
# Cette classe represente un joueur. Un joueur est defini par :
# == Un intitule (permet a la vue de reconnaitre l'objet)
# == Un nombre de Repos representant le nombre de repos restant au joueur
# == Un niveau, correspondant au niveau actuel du joueur
# == Une valeur d'energie correspondant au niveau d'energie actuel du joueur
# == Un seuil d'energie, correspondant a la valeur maximal d'energie du joueur
# == Une valeur d'experience, correspondant a l'experience actuelle du joueur
# == Un seuil d'experience, correspondant au maximum d'experience pour le niveau actuel, s'il est franchi, le joueur prend un niveau et l'experience repart a 0
# == Un boolean tourDejaPasse indiquant si le joueur peut encore interagir ou non
# == Un inventaire , correspondant un objet de type inventaire
# == Une case, correspondant a la case ou se trouve actuellement le joueur
# == Un equipement (armure, arme, bottes), representant les objets équipés par le joueur
# == Un pseudo, correspondant au pseudo du joueur
# == Un nombre d'ennemis tué, pour les statistiques
# == Une distance parcourue, correspondant au nombre de déplacements, pour les statistiques
#

require "./Enum/EnumDirection.rb"
require "./Element.rb"
require "./Personnage.rb"
require "./Interface/Deplacable.rb"
require "./Interface/Commercant.rb"
require "./Carte.rb"

class Joueur < Personnage
   include Deplacable, Commercant
   @intitule
   @nombreRepos
   @niveau
   @energie
   @energieMax
   @experience
   @experienceSeuil
   @inventaire
   @modele
   @casePosition
   @armure
   @bottes
   @arme
   @pseudo
   @nbEnnemiTues
   @distanceParcourue
   @causeMort
   @peutSEquiper

   attr_reader :nombreRepos, :niveau, :experience,
               :experienceSeuil, :inventaire, :casePosition, :nbEnnemiTues, :distanceParcourue,
               :causeMort, :peutSEquiper, :modele
   attr_accessor :armure, :arme, :bottes, :pseudo, :energie, :energieMax
   
   
   ##
   # Cree un nouveau Joueur a  partir des informations passees en parametre.
   #
   # == Parameters:
   # intitule : Un intitule (permet a la vue de reconnaitre l'objet)
   # nbRepos : integer representant le nombre de repos restant au joueur
   # energieMax : float representant le seuil d'energie maximum du joueur
   # experienceSeuil : float representant le seuil d'experience maximum du joueur
   # inventaire : inventaire du joueur
   # modele : permet au joueur de communiquer avec le modele
   # casePosition : case ou se situe le joueur
   # pseudo : pseudo du joueur
   #
   def Joueur.creer(nbRepos,energieMax,experienceSeuil,inventaire,modele,casePosition,pseudo)
      new(nbRepos,energieMax,experienceSeuil,inventaire,modele,casePosition,pseudo)
   end

   
   def initialize(nbRepos,energieMax,experienceSeuil,inventaire,modele,casePosition,pseudo)
      super(casePosition)
      @intitule="Joueur"
      @nombreRepos = nbRepos
      @niveau = 1
      @energie = energieMax
      @energieMax = energieMax
      @experience = 0
      @experienceSeuil = experienceSeuil
      @tourDejaPasse = false
      @inventaire = inventaire
      @modele = modele
      @armure=nil
      @arme=nil
      @bottes=nil
      @pseudo=pseudo
      @nbEnnemiTues=0
      @distanceParcourue=0
      @peutSEquiper=true
   end

   
   ##
   # Retourne une chaine de caractere representant la cle de l'image
   #
   def getIntitule()
      return @intitule
   end

   
   ##
   # Deplace le joueur
   #
   # Definit la methode _deplacement_.
   # Elle permet le deplacement sur une cible donnée
   # Elle prend en parametre une Direction _cible_.
   # appel DebutTour chez son modele une fois fini
   def deplacement(cible)

      if(@modele.tourDejaPasse == false)
         @modele.tourPasse()
      end
      if(self.toujoursEnVie?())
         @modele.tourDejaPasse = false;
         dest = @casePosition.getDestination(cible)
         if(dest != nil)
            dest.joueur = self
            @casePosition.joueur = nil
            @casePosition = dest
            @modele.notifier("Vous vous êtes déplacé à la case (#{@casePosition.coordonneeX};#{@casePosition.coordonneeY}) demandant #{@casePosition.typeTerrain.coutDeplacement*@modele.difficulte.pourcentageTerrain} points d'énergie.")
            if(@bottes!=nil)
              @modele.notifier("Vous avez utilisé vos #{@bottes.getIntitule()} ayant une protection de #{@bottes.typeEquipable.pourcentageProtection()*100}%")
              energiePerdue= (@casePosition.typeTerrain.coutDeplacement*@modele.difficulte.pourcentageTerrain()*(1-@bottes.typeEquipable.pourcentageProtection()))
              @modele.notifier("Vous perdez #{energiePerdu} points d'énergie")              
              @energie -= energiePerdu
              @bottes.nbTour=@bottes.nbTour-1
              if(@bottes.nbTour==0)
                 @bottes=nil
                 @modele.notifier("Vous perdez vos bottes.")
              else
                 @modele.notifier("Vos bottes peuvent êtres utilisées encore #{@bottes.nbTour} fois.")
              end
            else
              energiePerdue= (@casePosition.typeTerrain.coutDeplacement*@modele.difficulte.pourcentageTerrain)
              @energie -= energiePerdue
              @modele.notifier("Vous perdez #{energiePerdue} points d'énergie")
            end
            @distanceParcourue += 1
         end
         if(!toujoursEnVie?())
            @causeMort= "Vous êtes mort de fatigue !!"
         end
      end
      return nil
   end

   ##
   # Fait combattre le joueur
   # Prend en compte les objets équipés 
   # Decremente l'energie a partir de la valeur d'energie du monstre
   # Demande au modele de supprimer l'ennemi mort si le combat est gagné, incremente nbEnnemiTues, fait gagner de l'experience renvoi une liste d'item
   # Si l'energie de l'ennemi est égale a celle du joueur, alors ils s'entretuent, memes actions que lors d'un combat remporté, on signal au modele la mort du joueur, retourne un tableau vide
   # Si le joueur avait moins d'energie, on specifie la mort du joueur, retourne un tableau vide
   def combattreEnnemi(ennemi)
     @modele.notifier("Vous avez combattu un #{ennemi.getIntitule()} ayant une énergie de #{ennemi.energie}.")
     protection=0;
      if(self.armureEquip)
        protection=protection+@armure.typeEquipable.pourcentageProtection()
        @armure=nil
        @modele.notifier("Vous avez utilisé votre #{@armure.getIntule()} ayant une protection de #{@armure.pourcentageProtection()*100}%")
      end
      if(self.armeEquip)
        protection=protection+@arme.typeEquipable.pourcentageProtection()
        @arme=nil
        @modele.notifier("Vous avez utilisé votre #{@arme.getIntule()} ayant une protection de #{@arme.pourcentageProtection()*100}%")
      end
      if(protection>1)
        protection=1
        @modele.notifier("Votre équipement vous apporte une protection totale !")
      end
      energiePerdue=ennemi.energie*(1-protection)
      @energie -= energiePerdue
      @modele.notifier("Vous perdez #{energiePerdue} points d'énergie")
      if(@energie > 0)
         @modele.eliminerEnnemi(ennemi)
         gainExperience(ennemi.energie)
         @nbEnnemiTues += 1
         return ennemi.listeItem
      elsif(@energie == 0)
         @modele.eliminerEnnemi(ennemi)
         gainExperience(ennemi.energie)
         @nbEnnemiTues += 1
         @causeMort= "Suite à un enchainement de coups fulgurants, vous avez mis fin à votre ennemi, mais ce dernier vous à emporté avec lui!! "
      else
         @causeMort ="Vous êtes mort au combat !!"
      end
      
      return Array.new()
   end

   ##
   # Verifie si le joueur a equipé une armure
   def armureEquip()
      return self.armure!=nil
   end

   ##
   # Verifie si le joueur a equipé une arme
   def armeEquip()
      return self.arme!=nil
   end

   ##
   # Demande a l'item de s'utiliser sur le joueur
   def utiliserItem(item)
      item.utiliseToi(self)
      @modele.tourPasse()
      return nil
   end

   # Definit la methode _deplacementIntelligent_.
   # non utilisée pour le joueur
   def deplacementIntelligent()
     return nil
   end

   ##
   # Fait passer un niveau au joueur
   def passeNiveau()
      @niveau += 1
      @experienceSeuil *= 1.2
      @energieMax*=1.2
      @energie=energieMax
      @modele.notifier("LVL UP #{@niveau}!! Votre énergie est réstitué et est plus grande désormais.")
      if(@niveau%5 == 0)
         @nombreRepos += 1
         @modele.notifier("Vous gagnez un repos supplémentaire.")
      end
      return nil
   end

   ##
   # Fait gagner de l'experience au joueur, si le Seuil d'experience est depassé, fait gagner un niveau
   # a voir le calcul du seuil d'experience
   def gainExperience(xp)
      @experience=@experience+xp
      @modele.notifier("+ #{xp}XP")
     
     while(@experience>=@experienceSeuil) do
       @experience=@experience-@experienceSeuil  
       passeNiveau()
         
      end
      
      return nil
   end
   

   ##
   # Transfert un item du vendeur vers le joueur
   # Perte d'argent du joueur
   def acheter(vendeur,item)
      vendeur.retirerDuStock(item)
      vendeur.encaisser(itemAchete.prix())
      ajouterAuStock(item)
      debourser(itemAchete.prix())
      @modele.notifier("Vous avez acheté #{item.getIntitule}.")
      @modele.tourPasse()
   end

   ##
   # Transfert un item du vendeur vers le joueur
   # Gain d'argent du joueur
   #
   def vendre(acheteur,item)
      retirerDuStock(item)
      encaisser(itemAchete.prix())
      acheteur.ajouterAuStock(item)
      acheteur.debourser(itemAchete.prix())
      @modele.notifier("Vous avez vendu #{item.getIntitule}.")
      @modele.tourPasse()
   end

   ##
   # Ajoute un item dans l'inventaire
   def ajouterAuStock(item)
      @inventaire.ajouter(item)
   end

   ##
   # Retire un item de l'inventaire
   def retirerDuStock(item)
      @inventaire.retirer(item)
   end

   ##
   # Encaisse une somme d'argent
   # methode d'ajout de revenue
   def encaisser(revenue)
      @inventaire.capital+=revenue
      @modele.notifier("Vous avez empochez #{revenue}.")
   end

   ##
   # Debourse une somme d'argent
   def debourser(revenue)
      @inventaire.capital-=revenue
      @modele.notifier("Vous déboursez #{revenue}.")
   end

   def toujoursEnVie?()
      return @energie > 0
   end

   ##
   # Consomme un repos
   def utiliserRepos()
     @peutSEquiper=true
     @nombreRepos=@nombreRepos-1
     @modele.notifier("Vous utilisez un repos.")
      i=10
      begin
         @energie=@energie+@energieMax*0.1
         if(@energie>@energieMax)
            @energie=@energieMax
         end
         i=i-1
         @modele.tourPasse()
         if(@casePosition.presenceEnnemis?())
           @modele.notifier("Vous êtes attaqué pendant votre sommeil, seul #{10-i} tours sur 10 sont passé.")
           @peutSEquiper=false
           break
         end
      end while(i>0)
      if(i==10)
        @modele.notifier("Votre repos a été ininterompue, vous recouvrez toutes votre santé.")
      end
   end

   ##
   # Ramasse un item
   # params: item
   def ramasserItem(item)
     @itemAttenteAjout=item
     if(@inventaire.estPlein?())
        @modele.changerStadePartie(EnumStadePartie.INVENTAIRE_PLEIN)
     else
        @inventaire.ajouter(item)
        @modele.notifier("Vous avez ramassé #{item.getIntitule}.")
     end
     @casePosition.retirerElement(item)
     @modele.tourPasse()
     test=1
   end
   

   ##
   # Retourne une chaine de caracteres reprenant les différentes caracteristiques
   # de l'objet Joueur sur lequel il a été appelé
   def to_s
      s= "[==Joueur >>> | "
      s+= super()
      s+= "Intitulé: #{@intitule} | "
      s+= "Nb de repos: #{@nombreRepos} | "
      s+= "Niveau: #{@niveau} | "
      s+= "Energie #{@energie} | "
      s+= "EnergieMax #{@energieMax} | "
      s+= "Experience #{@experience} | "
      s+= "ExperienceSeuil #{@experienceSeuil} | "
      s+= "Inventaire #{@inventaire} | "
      s+= "Armure #{@armure} | "
      s+= "Arme #{@arme} | "
      s+= "Bottes #{@bottes} | "
      s+= "Pseudo #{@pseudo} | "
      s+= "Nb ennemi tués #{@nbEnnemiTues} | "
      s+= "Distance parcourue #{@distanceParcourue} | "
      s+= "Message cause mort: #{@causeMort} | "
      if(@peutSEquiper)
        s+= "Peut s'équiper | "
      else
        s+= "Ne peut pas s'équiper | "
      end
      s+= "<<< Joueur==]"
      return s
   end

end