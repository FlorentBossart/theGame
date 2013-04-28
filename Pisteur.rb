#!/usr/bin/env ruby

##
# Fichier         : Pisteur.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe représente un personnage non joueur ennemi pisteur.
#  Un personnage non joueur ennemi pisteur est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Un type
#* Une energie
#* Un niveau
#* Un joueur à pister
#* Une distance de pistage
#

require './Ennemi.rb'
require './Joueur.rb'

class Pisteur < Ennemi

   @joueur
   @distancePistage

    
   ##
   # Crée un nouvel Ennemi pisteur à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi pisteur
   #* <b>niveau :</b> le niveau de l'ennemi pisteur
   #* <b>type :</b> le type de l'ennemi pisteur
   #* <b>joueur :</b> le joueur à pister
   #
   def initialize(casePosition, niveau, type, joueur)
      super(casePosition, niveau, type)
      @joueur = joueur
      @distancePistage = 4
   end

   
   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera l'ennemi pisteur
   #* <b>niveau :</b> le niveau de l'ennemi pisteur
   #* <b>type :</b> le type de l'ennemi pisteur
   #* <b>joueur :</b> le joueur à pister
   #
   def Pisteur.creer(casePosition, niveau, type, joueur)
      return new(casePosition, niveau, type, joueur)
   end

   
   ##
   # Permet de deplacer l'Ennemi sur une cible calculée suivant la position du joueur.
   #
   def deplacementIntelligent()
      cj = @joueur.casePosition # CaseJoueur
      list_case = Array.new()   # Liste de listes de cases
      indice = 0                # Indice
      find = false              # Boolean pour savoir si le joueur a été trouvé

      if(!(cj == self.casePosition))

         # Recherche de la case du joueur
         list_case[indice] = Array.new().push(@casePosition)

         while(!find)
            list_case[indice+1] = Array.new()
            ajoutList = list_case[indice+1]

            for c in list_case[indice]

               if(!existe(c.CaseNord, list_case, indice) && estAccessible(c.CaseNord))
                  ajoutList.push(c.CaseNord)
                  if(estCible(c.CaseNord))
                     find = true
                     break
                  end
               end

               if(!existe(c.CaseSud, list_case, indice) && estAccessible(c.CaseSud))
                  ajoutList.push(c.CaseSud)
                  if(estCible(c.CaseSud))
                     find = true
                     break
                  end
               end

               if(!existe(c.CaseEst, list_case, indice) && estAccessible(c.CaseEst))
                  ajoutList.push(c.CaseEst)
                  if(estCible(c.CaseEst))
                     find = true
                     break
                  end
               end

               if(!existe(c.CaseOuest, list_case, indice) && estAccessible(c.CaseOuest))
                  ajoutList.push(c.CaseOuest)
                  if(estCible(c.CaseOuest))
                     find = true
                     break
                  end
               end

            end # Fin for

            ajoutList.uniq()  # Enleve les cases en doublons du tableau

            indice += 1
            
            if(indice >= 5) # Hors du champs de l'ennemi
               break
            end

         end # Fin while
         # Fin Recherche de la case du joueur

         # Determination de la case de deplacement
         if(find)
            puts "Le pisteur de la case " + @casePosition.to_s + " a repéré Le Joueur !"
            # Remplacement de la liste de case du derniere indice par la case du joueur
            list_case[indice] = Array.new().push(cj)

            while(indice > 0)
               caseFind = list_case[indice][0] # Derniere case du chemin trouvé
               listFind = list_case[indice-1]  # Liste contenant la case suivante du chemin

               if(listFind.index(caseFind.CaseNord) != nil)
                  listFind = Array.new().push(caseFind.CaseNord)
               elsif(listFind.index(caseFind.CaseSud) != nil)
                  listFind = Array.new().push(caseFind.CaseSud)
               elsif(listFind.index(caseFind.CaseEst) != nil)
                  listFind = Array.new().push(caseFind.CaseEst)
               elsif(listFind.index(caseFind.CaseOuest) != nil)
                  listFind = Array.new().push(caseFind.CaseOuest)
               end

               list_case[indice-1] = listFind
               indice -= 1

            end # Fin while
            
            if(list_case[1][0] == @casePosition.CaseNord)
               deplacement(EnumDirection.NORD)
            elsif(list_case[1][0] == @casePosition.CaseSud)
               deplacement(EnumDirection.SUD)
            elsif(list_case[1][0] == @casePosition.CaseEst)
               deplacement(EnumDirection.EST)
            else
               deplacement(EnumDirection.OUEST)
            end

            # Fin determination de la case de deplacement

            # Deplacement aleatoire du pisteur
         else
            super() # Appelle de la methode deplacementIntelligent de la classe Ennemi (aleatoire)
         end # Fin if(find)

      end # Fin if(!(cj == self.casePosition))

   end # Fin methode

   
   ##
   # Permet de savoir si une case à déjà était marqué.
   #
   # == Parameters:
   #* <b>uneCase :</b> la case à vérifier
   #* <b>list_case :</b> la liste qui contient les cases marquées
   #* <b>indice :</b> l'indice du dernier ajout
   #
   def existe(uneCase, list_case, indice)
      for i in 0..indice
         if(list_case[i].index(uneCase) != nil)
            return true
         end
      end

      return false
   end

   
   ##
   # Permet de savoir si une case est accessible
   #
   # == Parameters:
   #* <b>uneCase :</b> la case à vérifier
   #
   def estAccessible(uneCase)
      if(uneCase.isFull || !uneCase.typeTerrain.isAccessible)
         return false
      end

      return true
   end

   
   ##
   # Permet de savoir si une case est la cible
   #
   # == Parameters:
   #* <b>uneCase :</b> la case à vérifier
   #
   def estCible(uneCase)
      if(uneCase == @joueur.casePosition)
         return true
      end

      return false
   end

   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Pisteur sur lequel la méthode est appellée.
   #
   def to_s
      return "[Pisteur Type #{@type} | Energie #{@energie} | Niveau #{@niveau} | DistancePistage #{@distancePistage}]"
   end

end