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

require 'MODELE/Ami.rb'
require 'MODELE/Interface/Commercant.rb'
require 'MODELE/Type/TypeEquipable.rb'
require 'MODELE/Equipable.rb'
require 'MODELE/Type/TypeMangeable.rb'
require 'MODELE/Mangeable.rb'
require 'MODELE/Item.rb'
require 'MODELE/Bibliotheque/BibliothequeTypeEquipable.rb'
require 'MODELE/Bibliotheque/BibliothequeTypeMangeable.rb'
require 'MODELE/StockMarchand.rb'

class Marchand < Ami
   include Commercant

   @pourcentageReprise

   ##
   # Crée un nouvel Ami Marchand à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami marchand
   #
   def initialize(casePosition,stock)
      super(casePosition)
      @intitule = "Marchand"
      @listeItem=stock
      @pourcentageReprise=0.8
   end
  
   
   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ami marchand
   #
   def Marchand.creer(casePosition,stock)
      return new(casePosition,stock)
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
      vendeur.encaisser((item.caracteristique.type.prix*@pourcentageReprise).to_i)
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
      #acheteur.ajouterAuStock(item)
      #acheteur.debourser(item.caracteristique.type.prix)
      acheteur.acheter(item) #AFR
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
      return nil
   end
   
   
   ##
   # Permet au marchand de retirer un item de son stock.
   #
   # == Parameters:
   #* <b>item :</b> l'item à retirer du stock
   #
   def retirerDuStock(item)
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
   
  def description
    s=XmlMultilingueReader.lireTexte("descMarchand")
  end
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Marchand sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==Marchand >>> |"
      s+= super()
     s+= "Items: "
     if(@listeItem.itemsStock.empty?)
       s+= "aucun "
     end
     for i in @listeItem.itemsStock
       s+= "#{i}, "
     end
     s+="| "
      s+= "<<< Marchand==]"
   end
  
end
