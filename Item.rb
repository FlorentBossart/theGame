#!/usr/bin/env ruby

##
# Fichier        : Item.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un item défini par :
# == Une caractéristique
#

require './Elem.rb'

class Item < Elem

   @caracteristique
   @selected
   
   attr_reader :caracteristique
   
   def initialize(casePosition, caracteristique)
      super(casePosition)
      @caracteristique = caracteristique
   end
   
   def Item.creer(casePosition, caracteristique)
      new(casePosition, caracteristique)
   end

   def getIntitule()
      return @caracteristique.getIntitule()
   end

   def utiliseToi(joueur)
      @caracteristique.utiliseToi(joueur)
      joueur.inventaire.retirer(self)
      return nil
   end
   
   def estStockable?()
       return @caracteristique.estStockable?()
   end
   
  def estEquipable?()
         return @caracteristique.estEquipable?()
  end
    
   def selectionner()
       selected = true
   end
    
   def deselectionner()
        selected = true
   end
   
   def description
     return "#{@caracteristique.to_s}"
   end
   ##
   # Represente l'interaction avec un element present sur une case (dans ce cas ramasser un item)
   #
   def interaction(joueur)
     if(estStockable?())
       joueur.ramasserItem(self)
     else
       @caracteristique.utiliseToi(joueur)
       joueur.casePosition.retirerElement(self)
       joueur.modele.tourPasse()
     end
     @casePosition=nil
       if(joueur.inventaire.estPlein?()==false)

         joueur.modele.debutTour()
       end
     joueur.modele.vue.actualiser
     return nil
   end
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Item sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==Item >>> | "
      s+= super()
      s+= "Caracteristique: #{@caracteristique} | "
      s+= "<<< Item==]"
   end

end