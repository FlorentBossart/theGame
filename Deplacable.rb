##
# Auteur YANNIS VESSEREAU
# Version 0.1 : Date : 10/04/2013
#

require './AbstractInterface.rb'

# Interface Deplacable definissant les deplacements
module Deplacable
  include AbstractInterface
  
  # Definit la methode _deplacement_.
  # Elle permet le deplacement sur une cible donnée
  # Elle prend en parametre une Direction _cible_.
  def deplacement(cible)
    Deplacable.api_not_implemented(self)
  end
  
  # Definit la methode _deplacementIntelligent_.
  # Elle permet le deplacement intelligent
  def deplacementIntelligent()
    Deplacable.api_not_implemented(self)
  end
  
end