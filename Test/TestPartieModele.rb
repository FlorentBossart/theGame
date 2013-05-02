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
  puts "\nChoix difficulte (T(est),N(ovice),M(oyen),E(xpert)):"
  choixDifficulte = gets.chomp
  if(choixDifficulte == "T")
    difficulte = BibliothequeDifficulte.getDifficulte("difficulteDeTest")
  elsif(choixDifficulte == "N")
    difficulte = BibliothequeDifficulte.getDifficulte("novice")
  elsif(choixDifficulte == "M")
    difficulte = BibliothequeDifficulte.getDifficulte("moyen")
  elsif(choixDifficulte == "E")
      difficulte = BibliothequeDifficulte.getDifficulte("expert")
  end
end while(choixDifficulte!="T" && choixDifficulte!="N" && choixDifficulte!="M" && choixDifficulte!="E" )

# Initialisation du modele
modele = Modele.creer(vueDeTest,difficulte,pseudo)

controleurDeTest.defM(modele)
vueDeTest.defMetC(modele,controleurDeTest)

modele.initialiseToi()

modele.lancerPartie()










