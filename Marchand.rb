#!/usr/bin/env ruby

##
# Fichier         : Marchand.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe représente un personnage non joueur Ami Marchand. 
#  Un personnage non joueur Ami Marchand est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Une image le représentant
#

require './Ami.rb'
require './Interface/Commercant.rb'
require './Type/TypeEquipable.rb'
require './Equipable.rb'
require './Type/TypeMangeable.rb'
require './Mangeable.rb'
require './Item.rb'
require './Bibliotheque/BibliothequeTypeEquipable.rb'
require './Bibliotheque/BibliothequeTypeMangeable.rb'

class Marchand < Ami
   include Commercant


   ##
   # Crée un nouvel Ami Marchand à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami marchand
   #
   def initialize(casePosition)
      super(casePosition)
      @intitule = "Marchand"
      remplirListeItems(40,50)
   end
  
   
   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami marchand
   #
   def Marchand.creer(casePosition)
      return new(casePosition)
   end
  
   
   ##
   # Permet au marchand d'acheter un item à un vendeur.
   #
   # == Parameters:
   #* <b>vendeur :</b> le vendeur à qui on achéte l'item
   #* <b>item :</b> l'item acheté
   #
   def acheter(vendeur, item)
      vendeur.retirerDuStock(item)
      ajouterAuStock(item)
      debourser(item.caracteristique.type.prix)
      vendeur.encaisser(item.caracteristique.type.prix)
      AffichageDebug.Afficher("#{item} \nacheté à \n#{vendeur}")
      return nil
   end

   
   ##
   # Permet au marchand de vendre un item à un acheteur.
   #
   # == Parameters:
   #* <b>acheteur :</b> l'acheteur à qui on vend l'item
   #* <b>item :</b> l'item vendu
   #
   def vendre(acheteur, item)
      retirerDuStock(item)
      acheteur.ajouterAuStock(item)
      acheteur.debourser(item.caracteristique.type.prix)
      encaisser(item.caracteristique.type.prix)
      AffichageDebug.Afficher("#{item} \nvendu à \n#{acheteur}")
      return nil
   end
 
    
   ##
   # Permet au marchand d'ajouter un item à son stock.
   #
   # == Parameters:
   #* <b>item :</b> l'item à ajouter au stock
   #
   def ajouterAuStock(item)
      @listeItem.push(item)
      AffichageDebug.Afficher("#{item} \najouté au stock de \n#{self}")
      return nil
   end
   
   
   ##
   # Permet au marchand de retirer un item de son stock.
   #
   # == Parameters:
   #* <b>item :</b> l'item à retirer du stock
   #
   def retirerDuStock(item)
      @listeItem.delete(item)
      AffichageDebug.Afficher("#{item} \nretiré du stock de \n#{self}")
      return nil
   end
   
   def encaisser(revenue)
         return nil
   end
    
    ##
    # Debourse une somme d'argent
    def debourser(revenue)
       return nil
    end
   
  ##
  # Represente l'interaction avec un element present sur une case (dans ce cas interargir avec un commercant)
  #
  def interaction(joueur)
    joueur.modele.pnjAideEnInteraction=self  
    joueur.modele.changerStadePartie(EnumStadePartie.INTERACTION_MARCHAND)
  end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Marchand sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==Marchand >>> |"
      s+= super()
      s+= "<<< Marchand==]"
   end
  
end