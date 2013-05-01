##
# Auteur YANNIS VESSEREAU
# Version 0.1 : Date : 10/04/2013
#


# Classe TypeEnnemi modelisant le type d'un ennemi
class TypeEnnemi

   @intitule        # Represente l'image du type (acces biblio)
   @energieBase  # Represente l'energie de base du type

   # Lecture 
   attr_reader :intitule, :energieBase

   private_class_method :new
   
   # Initialise l'instance de la classe TypeEnnemi
   # avec les parametres String _intitule_ et Float _energieBase_.
   def initialize(intitule, energieBase)
      @intitule = intitule
      @energieBase = energieBase
   end

   # Appel de la méthode initialize.
   def TypeEnnemi.creer(intitule, energieBase)
      return new(intitule, energieBase)
   end

   ##
   # Retourne une chaîne de caractères reprenant les différentes caractéristiques
   # de l'objet TypeEnnemi sur lequel la méthode est appellée.
   #
   def to_s
      s= "[==TypeEnnemi >>> | "
      s+= "Intitulé: #{@intitule}  | "
      s+= "Energie de base: #{@energieBase} | "
      s+= "<<< TypeEnnemi==]"
      return s
   end
   
end

