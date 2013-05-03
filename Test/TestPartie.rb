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


# Creation de la vue
vue=Vue.new()

# Creation du modele
modele = Modele.creer(vue,difficulte,pseudo)
controller=Controller.creer(modele,vue)
vue.defM(modele)
vue.defC(controller)
modele.initialiseToi()
vue.initInterface()

# Initialisation du faux controleur
#controleurDeTest=Controller.new(modele,vueDeTest)

#controleurDeTest.defM(modele)
#vueDeTest.defMetC(modele,controleurDeTest)



modele.lancerPartie()

