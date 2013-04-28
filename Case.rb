require './Enum/EnumDirection.rb'
class Case
  
  
  ##
  #Variables d'instance
  @coordonneeX
  @coordonneeY
  @@NombreMaxElements = 5
  @listeElements
  @listeEnnemis
  @caseNord
  @caseSud
  @caseEst
  @caseOuest
  @typeTerrain
  @joueur

  attr_accessor :joueur, :listeEnnemis, :listeElements, :typeTerrain, :caseNord, :caseSud, :caseEst, :caseOuest
  
  private_class_method :new

  
  ##
  #Construction d'une case en lui donnant des coordonnées x et y, pour le moment le type est aléatoire
  #==Parameters
  #La position en x
  #la position en y
  def initialize(x,y)
    @coordonneeX = x
    @coordonneeY = y
    @listeEnnemis = Array.new()
    @listeElements = Array.new()
  end
  
  
  def estAccessible()
    return @typeTerrain.isAccessible
  end
  
  def presenceEnnemis
    puts "Nombre d'ennemis sur la case : " + @listeEnnemis.length.to_s
    return @listeEnnemis.length != 0
  end
  
  def presenceAides
      puts "Nombre d'aide sur la case : " + @listeElements.length.to_s
      return @listeElements.length != 0
  end
  

  def Case.nouvelle(x,y)
    return new(x,y)
  end

  ##
  #Ajout d'un ennemi sur la case si il reste de la place
  #==Parameters
  #ennemi correspondant à l'ennemi à poser sur la case
  def ajouterEnnemi(ennemi)
    if(!self.isFull)
      @listeEnnemis.push(ennemi)
    end
    return self
  end
 
    
    ##
    #Retrait d'un ennemi de la case
    #==Parameters
    #ennemi correspondant à l'ennemi à retirer
    def retirerEnnemi(ennemi)
       @listeEnnemis.delete(ennemi)
       return self
    end

  
  ##
  #Ajout d'un element de la case
  #==Parameters
  #element correspondant à l'element à ajouter
  def ajouterElement(element)
    if(!self.isFull)
      @listeElements.push(element)
    end
    return self
  end

  
  ##
  #Retrait d'un element de la case
  #==Parameters
  #element correspondant à l'element à retirer
  def retirerElement(element)
    @listeElements.delete(element)
    return self
  end

  def getDestination(direction)
    case direction
    when EnumDirection.NORD
      return @caseNord
    when EnumDirection.SUD
      return @caseSud
    when EnumDirection.EST
      return @caseEst
    when EnumDirection.OUEST
      return @caseOuest
    else
      raise 'Erreur, direction incohérente'
    end
  end

  
  ##
  #Retourne un booleen indiquant si la case est pleine ou non
  #==Returns
  #Boolean indiquant si le case est pleine
  def isFull
    return @@NombreMaxElements <= (@listeElements.length + @listeEnnemis.length)
  end

  
  ##
  #Initialisation des cases voisines à la case instanciée
  #==Parameters
  #Les quatres cases a proximité
  def initVoisines(nord,sud,est,ouest)
    @caseNord = nord
    @caseSud = sud
    @caseEst = est
    @caseOuest = ouest
    return self
  end

  
  def to_s
    return "[#{@coordonneeX}, #{@coordonneeY}, #{@typeTerrain}]"
  end
end
