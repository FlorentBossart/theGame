def declencherCombat
  listeEnnemi=self.joueur.casePosition.listeEnnemis()
  item=Array.new(taille)
  items=Array.new(taille)
  listeEnnemi.each{ |ennemi| 
    item=self.joueur.combattreEnnemi(ennemi)
    if(self.joueur.toujoursEnVie())
      item.each{ |it|
        items.push(it)
      }
    else
      break;
    end 
  }
end

bfwdndng