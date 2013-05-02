#!/usr/bin/env ruby

require './Modele.rb'
require './AffichageDebug.rb'
require './Controller.rb'
require './Vue.rb'


#AffichageDebug.On()

# Choix pseudo
puts "\nChoix pseudo:"
pseudo = gets.chomp

# Remplissage des bibliothèque
Modele.initialisationBibliotheques()

# Choix difficulté
begin
  puts "\nChoix difficulte (F,M,D):"
  choixDifficulte = gets.chomp
  if(choixDifficulte == "F")
    difficulte = BibliothequeDifficulte.getDifficulte("facile")
  elsif(choixDifficulte == "M")
    difficulte = BibliothequeDifficulte.getDifficulte("moyen")
  elsif(choixDifficulte == "D")
    difficulte = BibliothequeDifficulte.getDifficulte("difficile")
  end
end while(choixDifficulte!="F" && choixDifficulte!="M" && choixDifficulte!="D")


# Creation de la vue
vue=Vue.new()

# Creation du modele
modele = Modele.creer(vue,difficulte,pseudo)

vue.defM(modele)
vue.initInterface()

# Initialisation du faux controleur
#controleurDeTest=Controller.new(modele,vueDeTest)

#controleurDeTest.defM(modele)
#vueDeTest.defMetC(modele,controleurDeTest)


modele.initialiseToi()
modele.lancerPartie()

