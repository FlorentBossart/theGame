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
  @items
  @taille
  @nbItem
  
  attr_reader :items, :taille, :nbItem
  attr_accessor :capital
  
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
    @items=Array.new()
    @taille=taille
    @nbItem=0
  end
  
  ##
  # Ajoute un item a l'inventaire
  #
  #
  def ajouter(item)
    if(!self.estPlein?())
      @items.push(item)
      @nbItem=@nbItem+1
      AffichageDebug.Afficher("Ajout de \n#{item} dans \n#{self}")
      return nil
    end
  end
  
  ##
  # Retire un item a l'inventaire
  #
  #
  def retirer(item)
    @items.delete(item)
    @nbItem=@nbItem-1
    AffichageDebug.Afficher("Retrait de \n#{item} de \n#{self}")
    return nil
  end
  
  ##
  # Test si l'inventaire est plein
  #
  #
  def estPlein?()
    return @nbItem >= @taille
  end
  
  ##
  # Retourne une chaine de caracteres reprenant les différentes caracteristiques
  # de l'objet Inventaire sur lequel il a été appelé
  #
  def to_s
    s= "[==Inventaire  >>> | "
    s+= "Taille: #{@taille} | "
    s+= "Capital: #{@capital} | "
    s+= "Items: "
    if(@nbItem==0)
      s+="aucun "
    end
    for i in @items
      s+= "#{i} ,"
    end
    s+="| "
    s+="<<< Inventaire==]"
    return s
  end

end

