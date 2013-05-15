#!/usr/bin/env ruby

##
# Fichier         : Ennemi.rb
# Auteur          : L3SPI - Groupe de projet B
# Fait partie de  : TheGame
#
#  Cette classe abstraite représente un personnage non joueur ennemi. 
#  Un personnage non joueur ennemi est défini par :
#* Une case où il se situe
#* Une liste d'items
#* Un type
#* Une energie
#* Un niveau
#

require './PNJ.rb'
require './Type/TypeEnnemi.rb'
require './Enum/EnumDirection.rb'
require './Enum/EnumRarete.rb'
require './Interface/Deplacable.rb'

class Ennemi < PNJ
   include Deplacable
  
   @type
   @energie
   @niveau
   
   attr_reader :energie, :type, :niveau
  
   
   ##
   # Crée un nouvel Ennemi à partir des informations passées en paramètre.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ennemi
   #* <b>niveau :</b> le niveau du PNJ Ennemi
   #* <b>type :</b> le type de PNJ Ennemi
   #
   def initialize(casePosition, niveau, type)
     @listeItem = Array.new
      fourchette=3
      super(casePosition)
      @niveau = niveau-fourchette + rand(niveau-fourchette+1)
      if(@niveau<1)
        @niveau=1
      end
      @type = type
      @energie = @type.energieBase * 1.2**(@niveau-1)
      case @niveau
        when 1..5
          remplirListeItems(0,2,EnumRarete.GROSSIER(),EnumRarete.GROSSIER())
        when 6..10
          remplirListeItems(0,2,EnumRarete.GROSSIER(),EnumRarete.INTERMEDIAIRE())
        when 11..15   
          remplirListeItems(0,2,EnumRarete.INTERMEDIAIRE(),EnumRarete.INTERMEDIAIRE())  
        when 16..20   
          remplirListeItems(0,2,EnumRarete.INTERMEDIAIRE(),EnumRarete.RAFFINE())
        when 21..25
          remplirListeItems(0,2,EnumRarete.RAFFINE(),EnumRarete.RAFFINE()) 
        else
          remplirListeItems(0,2,EnumRarete.MAITRE(),EnumRarete.MAITRE())     
      end
      
   end
   
  ##
   # Permet de remplir aleatoirement la liste d'items.
   #
   def remplirListeItems(min,max,rareteMin,rareteMax)
      nbItems = rand(max-min) + min
    
      for i in 1..nbItems
         # Choix du type
         type = rand(8)+1
      
         case type
            when 1..2 # TypeEquipable
               type = BibliothequeTypeEquipable.getTypeEquipableAuHasardRarete(rareteMin,rareteMax)
               caract = Equipable.creer(type)
            when 3..4# TypeMangeable
               type = BibliothequeTypeMangeable.getTypeMangeableAuHasardRarete(rareteMin,rareteMax)
               caract = Mangeable.creer(type)
            else
               quantiteOr=(rand(10)+1)*@niveau
               caract=Encaissable.creer(quantiteOr)
         end # Fin case type
      
         @listeItem.push(Item.creer(nil, caract))
      end # Fin for
    
      return self
   end

  

   ##
   # Appel de la méthode initialize avec les paramètres necessaires.
   #
   # == Parameters:
   #* <b>casePosition :</b> la case où se trouvera le PNJ Ennemi
   #* <b>niveau :</b> le niveau du PNJ Ennemi
   #* <b>type :</b> le type de PNJ Ennemi
   #
   def Ennemi.creer(casePosition, niveau, type)
      if(self.class == Ennemi)
         raise "Subclass responsability"
      end
      return new(casePosition, niveau, type)
   end
  

   ##
   # Permet de deplacer l'Ennemi sur une cible donnée.
   #
   # == Parameters:
   #* <b>cible :</b> la cible de destination
   #
   def deplacement(cible)
      
     caseCible= @casePosition.getDestination(cible)
      
      if(!caseCible.isFull?() && caseCible.typeTerrain.isAccessible)
         @casePosition.retirerEnnemi(self)
        caseCible.ajouterEnnemi(self)
         @casePosition = caseCible
         AffichageDebug.Afficher("#{self} \ndéplacé dans \n#{caseCible}")
      else
     AffichageDebug.Afficher("#{self}\n pas déplacé")
      end
      return nil
   end
  

   ##
   # Permet de deplacer l'Ennemi sur une cible calculée aleatoirement.
   #
   def deplacementIntelligent()
      cible = rand(3)
    
      case cible
         when 0
            cible = EnumDirection.NORD
            if(!@casePosition.caseNord.isFull?() && @casePosition.caseNord.typeTerrain.isAccessible)
               deplacement(cible)
            else
              deplacement(EnumDirection.SUD)
            end
         when 1
            cible = EnumDirection.SUD
            if(!@casePosition.caseSud.isFull?() && @casePosition.caseSud.typeTerrain.isAccessible)
               deplacement(cible)
              else
                deplacement(EnumDirection.EST)
              end
         when 2
            cible = EnumDirection.EST
            if(!@casePosition.caseEst.isFull?() && @casePosition.caseEst.typeTerrain.isAccessible)
               deplacement(cible)
              else
                deplacement(EnumDirection.OUEST)
              end
         else
            cible = EnumDirection.OUEST
            if(!@casePosition.caseOuest.isFull?() && @casePosition.caseOuest.typeTerrain.isAccessible)
               deplacement(cible)
            end
      end 
   end
  
   
   ##
   # Retourne l'image representant le PNJ Ennemi.
   #
   def getIntitule()
      return @type.intitule
   end
  
   
   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet Ennemi sur lequel la méthode est appellée.
   #
   def to_s
     s= "Energie: #{@energie} | "
     s+= "Niveau: #{@niveau} | "
     s+= "Type: #{@type} | "
     s+= super()
   end
   
end