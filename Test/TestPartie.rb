#!/usr/bin/env ruby

require './Modele.rb'
require './AffichageDebug.rb'
require './Controller.rb'
require './Vue.rb'


#AffichageDebug.On()

# Initialisation de la fausse vue

#comm truc


#commentaire++



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
vueDeTest=Vue.new()
modele = Modele.creer(vueDeTest,difficulte,pseudo)



vueDeTest.defM(modele)
vueDeTest.initInterface()
# Initialisation du faux controleur
#controleurDeTest=Controller.new(modele,vueDeTest)

#controleurDeTest.defM(modele)
#vueDeTest.defMetC(modele,controleurDeTest)


modele.initialiseToi()
modele.lancerPartie()

