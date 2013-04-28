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

   attr_reader :intitule, :nombreRepos, :niveau, :energie, :energieMax, :experience, :experienceSeuil, :inventaire, :casePosition, :armure, :arme, :bottes, :pseudo, :nbEnnemiTues, :distanceParcourue, :causeMort, :peutSEquiper
   attr_writer :armure, :arme, :bottes, :pseudo
   
   
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
   def getIntitule
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
      if(self.toujourEnVie())
         @modele.tourDejaPasse = false;
         dest = getDestination(cible)
         if(dest != nil)
            dest.joueur = self
            @casePosition.joueur = nil
            @casePosition = dest
            if(@bottes!=nil)
               @energie -= (@casePosition.typeTerrain.coutDeplacement*@modele.difficulte.pourcentageTerrain()*(1-@bottes.pourcentageProtect()))
               @bottes.nbTour=@bottes.nbTour-1
               if(@bottes.nbTour==0)
                 @bottes=nil
               end
            else
               @energie -= (@casePosition.typeTerrain.coutDeplacement*@modele.difficulte.pourcentageTerrain)
            end
            @distanceParcourue += 1
         end
         if(!toujourEnVie())
            @causeMort= "Vous êtes mort de fatigue !!"
         end
      end
   end

   ##
   # Fait combattre le joueur
   # Prend en compte les objets équipés 
   # Decremente l'energie a partir de la valeur d'energie du monstre
   # Demande au modele de supprimer l'ennemi mort si le combat est gagné, incremente nbEnnemiTues, fait gagner de l'experience renvoi une liste d'item
   # Si l'energie de l'ennemi est égale a celle du joueur, alors ils s'entretuent, memes actions que lors d'un combat remporté, on signal au modele la mort du joueur, retourne un tableau vide
   # Si le joueur avait moins d'energie, on specifie la mort du joueur, retourne un tableau vide
   def combattreEnnemi(ennemi)

      protection=0;
      if(self.armureEquip)
        protection=protection+@armure.typeEquipable.pourcentageProtect()
        @armure=nil
      end
      if(self.armeEquip)
        protection=protection+@arme.typeEquipable.pourcentageProtect()
        @arme=nil
      end
      if(protection>1)
        protection=1
      end
      @energie -= ennemi.energie*(1-protection)
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
   end

   # Definit la methode _deplacementIntelligent_.
   # non utilisée pour le joueur
   def deplacementIntelligent()
   end

   ##
   # Fait passer un niveau au joueur
   def passeNiveau()
      @niveau += 1
      @experienceSeuil *= 1.2
      if(@niveau%5 == 0)
         @nombreRepos += 1
      end
   end

   ##
   # Fait gagner de l'experience au joueur, si le Seuil d'experience est depassé, fait gagner un niveau
   # a voir le calcul du seuil d'experience
   def gainExperience(xp)
      @experience=@experience+xp
      if(@experience>=@experienceSeuil)
         self.passeNiveau()
         @experience=@experience-@experienceSeuil
      end
   end

   ##
   # Transfert un item du vendeur vers le joueur
   # Perte d'argent du joueur
   def acheter(vendeur,item)
      vendeur.retirerDuStock(item)
      vendeur.encaisser(itemAchete.prix())
      self.ajouterAuStock(item)
      self.debourser(itemAchete.prix())
      @modele.tourPasse()
   end

   ##
   # Transfert un item du vendeur vers le joueur
   # Gain d'argent du joueur
   #
   def vendre(acheteur,item)
      self.retirerDuStock(item)
      self.encaisser(itemAchete.prix())
      acheteur.ajouterAuStock(item)
      acheteur.debourser(itemAchete.prix())
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
      @inventaire.ajouterCapital(revenue)
   end

   ##
   # Debourse une somme d'argent
   def debourser(revenue)
      @inventaire.retirerCapital(revenue)
   end

   def toujourEnVie()
      return @energie > 0
   end

   ##
   # Consomme un repos
   def utiliserRepos()
      @peutSEquiper=true
      @repos=@repos-1
      i=10
      begin
         @energie=@energie+@energieMax*0.1
         if(@energie>@energieMax)
            @energie=@energieMax
         end
         i=i-1
         @modele.tourPasse()
         if(@casePosition.presenceEnnemis())
           @peutSEquiper=false
           break
         end
      end while(i>0)
   end

   ##
   # Ramasse un item
   def ramasserItem(item)
     @itemAttenteAjout=item
     if(joueur.inventaire.estPlein)
        @modele.changerStadePartie(EnumStadePartie.INVENTAIRE_PLEIN)
     else
        @inventaire.ajouter(item) 
     end
     @modele.tourPasse()
   end
   
   
   ##
   # Retourne la case de destination   
   def getDestination(cible)
      case cible
         when EnumDirection.NORD
            cible = @casePosition.CaseNord
         when EnumDirection.SUD
            cible = @casePosition.CaseSud
         when EnumDirection.EST
            cible = @casePosition.CaseEst
         else
            cible = @casePosition.CaseOuest
      end
      
      if(cible.typeTerrain.isAccessible)
         return cible
      else
         return nil
      end
   end
   

   ##
   # Retourne une chaine de caracteres reprenant les différentes caracteristiques
   # de l'objet Joueur sur lequel il a été appelé
   def to_s
      s= "[image #{@image} ]"
      s+= "[nombreRepos #{@nombreRepos}]"
      s+= "[niveau #{@niveau}]"
      s+= "[energie #{@energie}]"
      s+= "[energieMax #{@energieMax}]"
      s+= "[experience #{@experience}]"
      s+= "[experienceSeuil #{@experienceSeuil}]"
      s+= "[tourDejaPasse #{@tourDejPasse}]"
      s+= "[inventaire #{@inventaire}]"
      s+= "[armure #{@armure}]"
      s+= "[arme #{@arme}]"
      s+= "[bottes #{@bottes}]"
      s+= "[pseudo #{@pseudo}]"
      s+= "[nbEnnemiTues #{@nbEnnemiTues}]"
      s+= "[distanceParcourue #{@distanceParcourue}]"
      return s
   end

end