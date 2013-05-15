require './Enum/EnumDirection.rb'
class Case
  
  
  ##
  @@NombreMaxElementsEnnemis = 5
  #Variables d'instance
  @coordonneeX
  @coordonneeY
  @listeElements
  @listeEnnemis
  @carte
  @typeTerrain
  @joueur


  attr_reader :listeEnnemis, :listeElements, :coordonneeX, :coordonneeY
  attr_accessor :typeTerrain,:joueur
  
  private_class_method :new

  
  ##
  #Construction d'une case en lui donnant des coordonnées x et y, pour le moment le type est aléatoire
  #==Parameters
  #La position en x
  #la position en y
  def initialize(x,y,carte,typeDefaut)
    @carte = carte
    @coordonneeX = x
    @coordonneeY = y
    @listeEnnemis = Array.new()
    @listeElements = Array.new()
    @typeTerrain = BibliothequeTypeTerrain.getTypeTerrain(typeDefaut)
	if @typeTerrain==nil 
	puts 'Grosse erreur'
	end
  end
  
  
  def estAccessible?()
    return @typeTerrain.isAccessible
  end
  
  def presenceEnnemis?()
    return @listeEnnemis.length != 0
  end
  
  def presenceAides?()
    return @listeElements.length != 0
  end
  
  def getIntitule()
    return @typeTerrain.intitule()
  end

  def Case.nouvelle(x,y,carte,typeDefaut)
    return new(x,y,carte,typeDefaut)
  end

  ##
  #Ajout d'un ennemi sur la case si il reste de la place
  #==Parameters
  #ennemi correspondant à l'ennemi à poser sur la case
  def ajouterEnnemi(ennemi)
    if(!self.isFull?())
      @listeEnnemis.push(ennemi)
    end
    AffichageDebug.Afficher("#{ennemi} \najouté dans \n#{self}")
    return nil
  end
 
    
    ##
    #Retrait d'un ennemi de la case
    #==Parameters
    #ennemi correspondant à l'ennemi à retirer
    def retirerEnnemi(ennemi)
       @listeEnnemis.delete(ennemi)
       AffichageDebug.Afficher("#{ennemi} \nsupprimé de \n#{self}")
       return nil
    end

  
  ##
  #Ajout d'un element de la case
  #==Parameters
  #element correspondant à l'element à ajouter
  def ajouterElement(element)
    if(!self.isFull?())
      @listeElements.push(element)
    end
    AffichageDebug.Afficher("#{element} \najouté à dans \n#{self}")
    return nil
  end

  
  ##
  #Retrait d'un element de la case
  #==Parameters
  #element correspondant à l'element à retirer
  def retirerElement(element)
    @listeElements.delete(element)
    AffichageDebug.Afficher("#{element} \nsupprimé de \n#{self}")
    return nil
  end

  def getDestination(direction)
    case direction
    when EnumDirection.NORD
      return @carte.getCaseAt(coordonneeX-1,coordonneeY)
    when EnumDirection.SUD
      return @carte.getCaseAt(coordonneeX+1,coordonneeY)
    when EnumDirection.EST
      return @carte.getCaseAt(coordonneeX,coordonneeY+1)
    when EnumDirection.OUEST
      return @carte.getCaseAt(coordonneeX,coordonneeY-1)
    else
      raise 'Erreur, direction incohérente'
    end
  end

  def caseNord
     return @carte.getCaseAt(coordonneeX-1,coordonneeY)
  end

  def caseSud
     return @carte.getCaseAt(coordonneeX+1,coordonneeY)
  end

  def caseEst
     return @carte.getCaseAt(coordonneeX,coordonneeY+1)
  end

  def caseOuest
     return @carte.getCaseAt(coordonneeX,coordonneeY-1)
  end
  
  ##
  #Retourne un booleen indiquant si la case est pleine ou non
  #==Returns
  #Boolean indiquant si le case est pleine
  def isFull?()
    return @@NombreMaxElementsEnnemis <= (@listeElements.length + @listeEnnemis.length)
  end
  
  def to_s
    s= "[==Case >>> | "
    s+= "X: #{@coordonneeX} | "
    s+= "Y: #{@coordonneeY} | "
    s+= "Elements: "
    if(@listeElements.empty?)
      s+="aucun "
    end
    for e in @listeElements
      s+= "#{e} ,"
    end
    s+="| "
    s+= "Ennemis: "
    if(@listeEnnemis.empty?)
      s+="aucun "
    end
    for e in @listeEnnemis
       s+= "#{e} ,"
    end
    s+="| "
    s+= "Terrain de type: #{@typeTerrain} | "
    if(@joueur==nil)
      s+= "Joueur: absent | "
    else
      s+= "Joueur: présent | "
    end
    s+= "Nombre max d'élements/ennemis: #{@@NombreMaxElementsEnnemis} | "
    s+= "<<< Case==]"
    return s
  end
 
end
