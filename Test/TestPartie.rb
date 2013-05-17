#!/usr/bin/env ruby

require './Modele.rb'
require './AffichageDebug.rb'
require './Controller.rb'
require './Vue.rb'
require './XMLReader/XmlMultilingueReader.rb'
require 'Audio.rb'

#AffichageDebug.On()

XmlMultilingueReader.setLangue("EN")
#XmlMultilingueReader.setLangue("FR")

# Remplissage des bibliothèque
Modele.initialisationBibliotheques()

Audio.load()

puts "\nChoix pseudo:"
pseudo = gets.chomp



# Choix difficulté
begin
  puts "\nChoix difficulte (T(est),N(ovice),M(oyen),E(xpert)):"
  choixDifficulte = gets.chomp
  if(choixDifficulte == "T")
    difficulte = BibliothequeDifficulte.getDifficulte("difficulteDeTest")
  elsif(choixDifficulte == "N")
    difficulte = BibliothequeDifficulte.getDifficulte("Novice")
  elsif(choixDifficulte == "M")
    difficulte = BibliothequeDifficulte.getDifficulte("Moyen")
  elsif(choixDifficulte == "E")
      difficulte = BibliothequeDifficulte.getDifficulte("Expert")
  end
end while(choixDifficulte!="T" && choixDifficulte!="N" && choixDifficulte!="M" && choixDifficulte!="E" )


# Creation de la vue
vue=Vue.creer()

# Creation du modele
modele = Modele.creer(vue,difficulte,pseudo)
controller=Controller.creer(modele,vue)
vue.defM(modele)
vue.defC(controller)
modele.initialiseToi()
vue.initInterface()

#ne sert à rien ici
# modele.lancerPartie()

