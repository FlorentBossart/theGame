class TestVue
  
  @controleurDeTest
  @modele
  
  private_class_method :new
      
  def TestVue.creer()
      return new()
  end
  
  def defMetC(modele,controleurDeTest)
    @modele=modele
    @controleurDeTest=controleurDeTest
  end
  
  def actualiser()
    case @modele.stadePartie
      
    #ETAPE CHOIX LIBRE
    when EnumStadePartie.CHOIX_LIBRE
      begin
        puts "_deplacement gauche(dg)"
        puts "_deplacement droite(dd)"
        puts "_deplacement haut(dh)"
        puts "_deplacement bas(db)"
        puts "_repos(r)"
        puts "_ouvrir inventaire(oi)"
        puts "_interaction(i)"
        puts "\nChoix:"
        choix = gets.chomp
        if(choix == "dg")
          if(@modele.joueur.casePosition.caseOuest.estAccessible?())
            @controleurDeTest.deplacementOuest()
          else
            puts "case ouest inaccessible"
          end
        elsif(choix == "dd")
          if(@modele.joueur.casePosition.caseEst.estAccessible?())
            @controleurDeTest.deplacementEst()
          else
            puts "case est inaccessible"
          end
        elsif(choix == "dh")
          if(@modele.joueur.casePosition.caseNord.estAccessible?())
            @controleurDeTest.deplacementNord()
          else
            puts "case nord inaccessible"
          end
        elsif(choix == "db")
          if(@modele.joueur.casePosition.caseSud.estAccessible?())
            @controleurDeTest.deplacementSud()
          else
            puts "case sud inaccessible"
          end
        elsif(choix == "r")
          if(@modele.joueur.nombreRepos!=0)
            @controleurDeTest.utiliserRepos()
          else
            puts "pas de repos"
          end
        elsif(choix == "oi")
          listeItemsJoueur = @modele.joueur.inventaire.items
          if(!listeItemsJoueur.empty?)
            begin
              puts "\nutiliser un item(u) ou supprimer un ou des items(s) ou annuler(a):"
              uOUs = gets.chomp
              if(uOUs=="u")
                begin
                  for i in 0 .. listeItemsJoueur.length-1
                    puts (i+1).to_s+") "+listeItemsJoueur[i].getIntitule()
                  end
                  puts "\nChoix item à utiliser(numero):"
                  choixItem = gets.chomp.to_i
                  if(choixItem >=1 && choixItem <= listeItemsJoueur.length)
                    @controleurDeTest.utiliserItem(listeItemsJoueur[choixItem-1])
                    break
                  end
                end while(!(choixItem >=1 && choixItem <=listeItemsJoueur.length))     
              elsif(uOUs=="s")
                listeASuppr=Array.new()
                begin
                  for i in 0 .. listeItemsJoueur.length-1
                    puts (i+1).to_s+") "+listeItemsJoueur[i].getIntitule()
                  end
                  puts "\nChoix item à supprimer(numero ou -1 pour valider):"
                  choixItem = gets.chomp.to_i
                  if(choixItem >=1 && choixItem <= listeItemsJoueur.length)
                    if(!listeASuppr.include?(listeItemsJoueur[choixItem-1]))
                      listeASuppr.push(listeItemsJoueur[choixItem-1])
                    else
                      puts "déjà selectionné"
                    end
                  end
                end while(choixItem != -1 && !(choixItem >=1 && choixItem <=listeItemsJoueur.length))
                @controleurDeTest.supprimerItems(listeASuppr)
              end
            end while(uOUs!="u" && uOUs!="s" && uOUs!="a")    
          else       
            puts "Inventaire vide"  
          end  
        elsif(choix == "i")
          listeAides=@modele.joueur.casePosition.listeElements
          if(!listeAides.empty?)
            begin
              for i in 0 .. listeAides.length-1
                puts (i+1).to_s+") "+(listeAides[i]).getIntitule()
              end
              puts "\nChoix interaction(numero ou -1 pour annuler):"
              choixElement = gets.chomp.to_i
              if(choixElement >=1 && choixElement <= listeAides.length)
                @controleurDeTest.interargir(listeAides[choixElement-1])
                break
              end
            end while(choixElement != -1 && !(choixElement >=1 && choixElement <=listeAides.length))
          elsif
            puts "Pas d'aides sur la cases"
          end
        end
      end while(choix != "dh" && choix != "db" && choix != "dg" && choix != "dd" && choix != "r" && choix != "oi" && choix != "i")   

    #ETAPE PARTIE PERDUE 
    when EnumStadePartie.PERDU
      puts "GAME OVER: "+@modele.messageDefaite
    
    #ETAPE EQUIPEMENT ARMURE   
    when EnumStadePartie.EQUIPEMENT_ARMURE
      listeArmures = Array.new()
      for i in @modele.joueur.inventaire.item
        if(i.estEquipable && i.caracteristique.typeEquipable.sePorteSur == "armure")
          listeArmures.push(i)
        end
      end
      begin
        for i in 0 .. listeArmures.length-1
          puts (i+1).to_s+") "+listeArmures[i].getIntitule()
        end
        puts "\nChoix armure à équiper (numero ou -1 pour aucune):"
        choix = gets.chomp.to_i
        if(choix >=1 && choix <=listeArmures.length)
          @controleurDeTest.equipeArmure(listeArmures[choix-1])
          break
        end
      end while(choix != -1 && !(choix >=1 && choix <=listeArmures.length))   
        
    #ETAPE EQUIPEMENT ARME           
    when EnumStadePartie.EQUIPEMENT_ARME
      listeArmes = Array.new()
      for i in @joueur.inventaire.item
        if(i.estEquipable && i.caracteristique.typeEquipable.sePorteSur == "arme")
          listeArmes.push(i)
        end
      end
      begin
        for i in 0 .. listeArmes.length-1
          puts (i+1)+") "+listeArmes[i]
        end
        puts "\nChoix arme à équiper (numero ou -1 pour aucune):"
        choix = gets.chomp.to_i
        if(choix >=1 && choix <=listeArmes.length)
          @controleurDeTest.equipeArme(listeArmes[choix-1])
          break
        end
      end while(choix != -1 && !(choix >=1 && choix <=listeArmes.length))
     
    #ETAPE INVENTAIRE PLEIN   
    when EnumStadePartie.INVENTAIRE_PLEIN
      listeItemsJoueur = @modele.inventaire.item
      aAjouter= @modele.itemAttenteAjout
      begin
        for i in 0 .. listeItemsJoueur.length-1
          puts (i+1).to_s+") "+listeItemsJoueur[i].getIntitule()
        end
        puts "A ajouter: "+aAjouter
        puts "\nChoix item à supprimer (numero ou -1 jeter le nouvel item):"
        choix = gets.chomp.to_i
        if(choix >=1 && choix <=listeItemsJoueur.length)
          @controleurDeTest.fairePlace(aAjouter,listeItemsJoueur[choix-1])
          break
        end
      end while(choix != -1 && !(choix >=1 && choix <=listeItemsJoueur.length))     
     
     #ETAPE INTERACTION MARCHAND      
     when EnumStadePartie.INTERACTION_MARCHAND  
       listeItemsJoueur = @modele.joueur.inventaire.items
       begin
         puts "\nachat(u) ou vente(v):"
         aOUv = gets.chomp
         if(aOUv=="v")
           begin
             for i in 0 .. listeItemsJoueur.length-1
               puts (i+1).to_s+") "+listeItemsJoueur[i].getIntitule()
             end
             puts "\nChoix item à vendre(numero):"
             choixItem = gets.chomp.to_i
             if(choixItem >=1 && choixItem <= listeItemsJoueur.length)
               @controleurDeTest.interactionMarchandAchat(@modele.pnjAideEnInteraction,listeItemsJoueur[choixItem-1]) 
               break 
             end
           end while(!(choixItem >=1 && choixItem <=listeItemsJoueur.length))     
         elsif(aOUv=="a")
           if(@modele.joueur.inventaire.estPlein)
             puts "Achat impossible: votre inventaire est plein"
           else
             listeItemsMarchand = @modele.pnjAideEnInteraction.listeItem
             begin
               for i in 0 .. listeItemsMarchand.length-1
                 puts (i+1).to_s+") "+listeItemsMarchand[i].getIntitule()
               end
               puts "\nChoix item à acheter(numero):"
               choixItem = gets.chomp.to_i
               if(choixItem >=1 && choixItem <= listeItemsMarchand.length)
                 @controleurDeTest.interactionMarchandVente(@modele.pnjAideEnInteraction,listeItemsMarchand[choixItem-1])
                 break
               end
             end while(!(choixItem >=1 && choixItem <=listeItemsJoueur.length))
           end
         end
       end while(aOUv!="v" && !(aOUv=="a" && !@modele.joueur.inventaire.estPlein)) 
    
    #ETAPE INTERACTOIN GUERISSEUR      
    when EnumStadePartie.INTERACTION_GUERISSEUR    
      begin
         puts "1)25%"
         puts "2)50%"
         puts "3)75%"
         puts "\nChoix (numero):"
         choixGuerison = gets.chomp.to_i
         if(choixGuerison >=1 && choixGuerison <=3)
            @controleurDeTest.interactionGuerisseur(@modele.pnjAideEnInteraction,choixGuerison-1)  
         end
      end while(!(choixGuerison >=1 && choixGuerison <=3))
    end #fin case
    
    for n in @modele.notifications
      puts "CONSOLE ->"+n
    end
    
    puts "\n>>>Données du Joueur<<<"
    puts "* Nom: #{@modele.joueur.pseudo}\n"
    puts "* LvL: #{@modele.joueur.niveau}\n"
    puts "* XP: #{@modele.joueur.experience}/#{@modele.joueur.experienceSeuil}\n"
    puts "* Energie: #{@modele.joueur.energie}/#{@modele.joueur.energieMax}\n"
    puts "* Repos: #{@modele.joueur.nombreRepos}\n"
    puts "* Or: #{@modele.joueur.inventaire.capital}\n"
    s= "* Armure:"
    if(@modele.joueur.armure==nil)
      s+= "aucune\n"
    else
      s+= "#{@modele.joueur.armure.getIntitule()}\n"
    end
    puts s
    s= "* Arme:"
    if(@modele.joueur.arme==nil)
      s+= "aucune\n"
    else
      s+= "#{@modele.joueur.arme.getIntitule()}\n"
    end
    puts s
    s= "* Bottes:"
    if(@modele.joueur.bottes==nil)
      s+= "aucune\n"
    else
      s+= "#{@modele.joueur.bottes.getIntitule()}\n"
    end
    puts s
    puts "* Ennemis tués: #{@modele.joueur.nbEnnemiTues}\n"
    puts "* Distance parcourue: #{@modele.joueur.distanceParcourue}\n"
    puts "* Tours passées: #{@modele.compteurTour}\n"
    puts "\n"
  end
  
end