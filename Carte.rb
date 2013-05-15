require './Case.rb'
require './Type/TypeTerrain.rb'
require './Enum/EnumDirection.rb'
require './Bibliotheque/BibliothequeTypeTerrain.rb'
#comcom
class Carte
    #machin
   @longueur
   @largeur
   @cases
   @joueur
   @id_terrainParDefaut

   private_class_method :new
   
   attr_reader :longueur, :largeur
   
   ##
   #Initialisation d'une carte avec pour argument sa longueur et sa largeur
   #==Parameters
   #longueur
   #largeur
   def initialize(long,larg,id_terrainDef)
      @longueur = long
      @largeur = larg
      @cases = Array.new()
      @id_terrainParDefaut=id_terrainDef
      for i in 0..long-1
         for j in 0..larg-1
            @cases.push(Case.nouvelle(i,j,self,@id_terrainParDefaut))
         end
      end
      generationMapSemiAleatoire()
   end

   def generationMapSemiAleatoire()
      0.upto((@longueur+@largeur)*2){
	Thread.new do
         tt = BibliothequeTypeTerrain.getTypeTerrainAuHasard
	repartitionType(tt,tt.probaRepartition,rand(@longueur),rand(@largeur))
      	end
	}
     return nil
   end

   def repartitionType(type, proba, coordX, coordY)  
      if(coordX >= @longueur || coordY >= @largeur || coordX < 0 || coordY < 0)
         return
      elsif(getCaseAt(coordX,coordY).typeTerrain == type)
         return
      else
         getCaseAt(coordX,coordY).typeTerrain = type
         (rand(100)<proba)?(repartitionType(type,proba-5,coordX-1,coordY)):(return)
         (rand(100)<proba)?(repartitionType(type,proba-5,coordX,coordY-1)):(return)
         (rand(100)<proba)?(repartitionType(type,proba-5,coordX+1,coordY)):(return)
         (rand(100)<proba)?(repartitionType(type,proba-5,coordX,coordY+1)):(return)
      end
      return
   end

   ##
   #Retrouver une case à des coordonnées x et y
   #==Parameters
   #x la coordonnée en X
   #y la coordonnée en Y
   def getCaseAt(x,y)
      return @cases[y%@largeur+(x%@longueur)*@largeur]
   end

   def Carte.nouvelle(long,larg,id_terrainDef)
      return new(long,larg,id_terrainDef)
   end
   
   def to_s()
     s= "[==Carte >>> | "
     s+= "Longueur: #{@longueur} | "
     s+= "Largeur: #{@largeur} | "
     s+= "Joueur: #{@joueur} | "
     s+= "Cases: "
     for c in @cases
      s+= "#{c} ,"
     end
     s+="| "
     s+= "<<< Carte==]"
     return s
   end

end
