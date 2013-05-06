class EnumStadePartie
  @@ETAPE_FINIE             = 1
  @@CHOIX_LIBRE             = 2
  @@PERDU                   = 3
  @@EQUIPEMENT_ARMURE       = 4
  @@EQUIPEMENT_ARME         = 5
  @@INVENTAIRE_PLEIN        = 6
  @@INTERACTION_MARCHAND    = 7 
  @@INTERACTION_GUERISSEUR  = 8
  @@INTERACTION_MARCHAND_ACHAT  = 9
  @@INTERACTION_MARCHAND_VENTE  = 10

  def EnumStadePartie.ETAPE_FINIE
    return @@ETAPE_FINIE
  end
    
  def EnumStadePartie.CHOIX_LIBRE
    return @@CHOIX_LIBRE
  end
  
  def EnumStadePartie.PERDU
    return @@PERDU
  end
  
  def EnumStadePartie.EQUIPEMENT_ARMURE
    return @@EQUIPEMENT_ARMURE
  end
    
  def EnumStadePartie.EQUIPEMENT_ARME
    return @@EQUIPEMENT_ARME
  end
  
  def EnumStadePartie.INVENTAIRE_PLEIN
    return @@INVENTAIRE_PLEIN
  end
  
  def EnumStadePartie.INTERACTION_MARCHAND
    return @@INTERACTION_MARCHAND
  end
  
  def EnumStadePartie.INTERACTION_GUERISSEUR
    return @@INTERACTION_GUERISSEUR
  end
  
  def EnumStadePartie.INTERACTION_MARCHAND_ACHAT
      return @@INTERACTION_MARCHAND_ACHAT
  end  
  
  def EnumStadePartie.INTERACTION_MARCHAND_VENTE
      return @@INTERACTION_MARCHAND_VENTE
  end
  
end