require 'AffichageDebug.rb'
require 'MODELE/Item.rb'
require 'MODELE/Bibliotheque/BibliothequeTypeEquipable.rb'
require 'MODELE/Bibliotheque/BibliothequeTypeMangeable.rb'
require 'XMLReader/XmlEquipablesReader.rb'
require 'XMLReader/XmlMangeablesReader.rb'

class StockMarchand
 
  @itemsStock
  
  private_class_method :new
  
  attr_reader :itemsStock 
   
  def initialize()
    @itemsStock=Array.new()
    caracteristiquesDuJeu=BibliothequeTypeEquipable.getTypes()
    for c in caracteristiquesDuJeu
      caract = Equipable.creer(c)
      @itemsStock.push(Item.creer(nil,caract))
    end
    caracteristiquesDuJeu=BibliothequeTypeMangeable.getTypes()
    for c in caracteristiquesDuJeu
      caract = Mangeable.creer(c)
      @itemsStock.push(Item.creer(nil,caract))
    end
  end
  
  def StockMarchand.creer()
    return new()
  end
    
  def genererItem(i)
    return Item.creer(nil,@itemsStock[i].caracteristique)
  end
  
end

