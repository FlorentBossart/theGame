#!/usr/bin/env ruby

##
# Fichier        : Element.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente un élément défini par :
# == Une case corespondant à sa position
# C'est une classe abtraite.
#

class Element
    
    @casePosition
    
    attr_reader :casePosition
    
    private_class_method :new
    
    
    ##
    # Crée un nouveau Element à partir des informations passées en paramètre.
    #
    # == Parameters:
    # casePosition : un objet Case corespondant à la case où se trouvera l'Element
    #
    def initialize(casePosition)
        @casePosition=casePosition
    end
    
    
    ##
    # Appel de la méthode initialize.
    #
    # == Parameters:
    # casePosition : un objet Case corespondant à la case où se trouvera l'Element
    #
    def Element.creer(casePosition)
        if(self.class==Element)
          raise "Subclass responsability"
        end
        return new(casePosition)
    end
    
    
    ##
    # (Abstraite) Renvoi la clé pour accèder à l'image dans la table  de RefGraphiques.
    #
    def getIntitule()
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
