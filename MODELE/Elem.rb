#!/usr/bin/env ruby

##
# Fichier        : Elem.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un élément défini par :
# == Une case corespondant à sa position
# C'est une classe abtraite.
#

#require './Modele.rb'

class Elem
    
    @casePosition
    @rangCase
    @anciennePositionX
    @anciennePositionY
    @ancienRangCase
    @tourDeCreation
    
    attr_reader :casePosition, :rangCase, :anciennePositionX, :anciennePositionY, :ancienRangCase
    
    private_class_method :new
    
    
    ##
    # Crée un nouveau Element à partir des informations passées en paramètre.
    #
    # == Parameters:
    # casePosition : un objet Case corespondant à la case où se trouvera l'Element
    #
    def initialize(casePosition)
        if(casePosition!=nil)
          nbElemCase=casePosition.listeElements.length+casePosition.listeEnnemis.length
          @rangCase=nbElemCase+1
        else
          @rangCase=-1
        end
         @anciennePositionX=-1
         @anciennePositionY=-1
         @ancienRangCase=-1
        @casePosition=casePosition
        @tourDeCreation=Modele.Cpt
    end
    
    
    ##
    # Appel de la méthode initialize.
    #
    # == Parameters:
    # casePosition : un objet Case corespondant à la case où se trouvera l'Element
    #
    def Elem.creer(casePosition)
        if(self.class==Elem)
          raise "Subclass responsability"
        end
        return new(casePosition)
    end
    
    def vientDEtreGenere?()
      return (@tourDeCreation==Modele.Cpt)
    end
    
    ##
    # (Abstraite) Renvoi la clé pour accèder à l'image dans la table  de RefGraphiques.
    #
    def getIntitule()
    end
    
  ##
  # (Abstraite) Renvoi une chaine de caractères pour les infobulles
  #
  def description()
  end
    
    ##
    # Retourne une chaîne de caractères reprenant les différentes caractéristiques
    # de l'objet Element sur lequel la méthode est appellée.
    #
    def to_s()
      if(@casePosition==nil)
        return "Position: n'est pas sur la carte | "
      else
        return "Position: (#{@casePosition.coordonneeX};#{@casePosition.coordonneeY}) | "
      end
    end
    
end
