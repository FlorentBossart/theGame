##
# Fichier        : Inventaire.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# TODO :
# -test de la classe
#
# Remarques:
# 
# 
#
#
# Cette classe represente un inventaire. Un inventaire est defini par :
# == Un capital, representant l'argent du joueur
# == Une liste d'objets, correspondant aux objets presents dans l'inventaire
# == Une taille, correspondant a la taile de l'inventaire
# == Un nombre d'item, correspondant au nombre d'items actuellement presents dans l'inventaire
#

class Inventaire

  @capital
  @item
  @taille
  @nbItem
  attr_reader :capital, :item, :taille, :nbItem
  ##
  # Cree un nouvel inventaire a  partir des informations passees en parametre.
  #
  # == Parameters:
  # taille: represente la taille de l'inventaire
  #
  def Inventaire.creer(taille)
    new(taille)
  end
  
  def initialize(taille)
    @capital=0
    @item=Array.new()
    @taille=taille
    @nbItem=0
  end
  
  ##
  # Ajoute un item a l'inventaire
  #
  #
  def ajouter(item)
    if(!self.estPlein())
      @item.push(item)
      @nbItem=@nbItem+1
    end
  end
  
  ##
  # Retire un item a l'inventaire
  #
  #
  def retirer(item)
    @item.delete(item)
    @nbItem=@nbItem-1
  end
  
  ##
  # Test si l'inventaire est plein
  #
  #
  def estPlein()
    return @nbItem >= @taille
  end
  
  ##
  # Retourne une chaine de caracteres reprenant les différentes caracteristiques
  # de l'objet Inventaire sur lequel il a été appelé
  #
  def to_s
    s= "[taille #{@taille} ]"
    s+= "[capital #{@capital}]"
    s+= "[item #{@item}]"
    return s
  end

end


#Test de la classe :
