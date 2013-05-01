##
# Auteur YANNIS VESSEREAU
# Version 0.1 : Date : 10/04/2013
#

require './AbstractInterface.rb'

# Interface Commercant definissant les actions d'un commercant
module Commercant
  include AbstractInterface
  
  # Definit la methode _acheter_.
  # Elle permet au commercant d'acheter un item à un vendeur
  # Elle prend en parametres un Personnage _vendeur_
  # et un Item _item_.
  def acheter(vendeur, item)
    Commercant.api_not_implemented(self)
  end

  # Definit la methode _vendre_.
  # Elle permet au commercant de vendre un item à un acheteur
  # Elle prend en parametres un Personnage _acheteur_
  # et un Item _item_.
  def vendre(acheteur, item)
    Commercant.api_not_implemented(self)
  end
  
  # Definit la methode _ajouterAuStock_.
  # Elle permet au commercant d'ajouter un item à son stock
  # Elle prend en parametre un Item _item_
  def ajouterAuStock(item)
    Commercant.api_not_implemented(self)
  end
  
  # Definit la methode _retirerDuStock_.
  # Elle permet au commercant de retirer un item de son stock
  # Elle prend en parametre un Item _item_
  def retirerDuStock(item)
    Commercant.api_not_implemented(self)
  end
  

  
end