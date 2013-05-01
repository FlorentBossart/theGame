require './Enum/EnumDirection.rb'
class Case
  
  
  ##
  @@NombreMaxElementsEnnemis = 5
  #Variables d'instance
  @coordonneeX
  @coordonneeY
  @listeElements
  @listeEnnemis
  @caseNord
  @caseSud
  @caseEst
  @caseOuest
  @typeTerrain
  @joueur

  attr_reader :caseNord, :caseSud, :caseEst, :caseOuest, :listeEnnemis, :listeElements, :coordonneeX, :coordonneeY
  attr_accessor :typeTerrain,:joueur
  
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
    @typeTerrain = BibliothequeTypeTerrain.getTypeTerrain("Plaine")
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
  

  def Case.nouvelle(x,y)
    return new(x,y)
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
  def isFull?()
    return @@NombreMaxElementsEnnemis <= (@listeElements.length + @listeEnnemis.length)
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
    return nil
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
