require './AffichageDebug.rb'
require './Item.rb'
require './Bibliotheque/BibliothequeTypeEquipable.rb'
require './Bibliotheque/BibliothequeTypeMangeable.rb'
require './XMLReader/XmlEquipablesReader.rb'
require './XMLReader/XmlMangeablesReader.rb'

class StockMarchand
 
  @itemsStock
  
  private_class_method :new
  
  attr_reader :itemsStock 
   
  def initialize()
    @itemsStock=Array.new()
    caracteristiquesDuJeu=BibliothequeTypeEquipable.getTypes()+BibliothequeTypeMangeable.getTypes()
    for c in caracteristiquesDuJeu
      @itemsStock.push(Item.creer(nil,c))
    end
  end
  
  def StockMarchand.creer()
    return new()
  end
    
  def genererItem(i)
    return Item.creer(nil,@itemsStock[i].caracteristique)
  end
  
end

