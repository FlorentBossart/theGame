#!/usr/bin/env ruby

require './AffichageDebug.rb'
require './Test/TestControleur.rb'
require './Test/TestVue.rb'
require './Modele.rb'

#AffichageDebug.On()

# Initialisation de la fausse vue
vueDeTest=TestVue.creer()

# Initialisation du faux controleur
controleurDeTest=TestControleur.creer()

puts "\nChoix pseudo:"
pseudo = gets.chomp

Modele.initialisationBibliotheques()

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

# Initialisation du modele
modele = Modele.creer(vueDeTest,difficulte,pseudo)

controleurDeTest.defM(modele)
vueDeTest.defMetC(modele,controleurDeTest)

modele.initialiseToi()

modele.lancerPartie()










