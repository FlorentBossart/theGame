#!/usr/bin/env ruby

#Zone de test du model

require './Type/Difficulte.rb'
require './Modele.rb'
require './Enum/EnumDirection.rb'
require './Bibliotheque/BibliothequeDifficulte.rb'

Modele.initialisationBibliotheques()

puts "\nTEST MODELE"
puts "\nChoix pseudo:"
pseudo = gets.chomp
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

# Initialisation du model
m = Modele.creer("Vue",difficulte,pseudo)

puts "\nLe joueur se trouve sur la case " + m.joueur.casePosition.to_s()

# Simulation de deplacement du joueur
while(!m.partiePerdue())
   m.joueur.deplacement(EnumDirection.SUD)
   puts "\nLe joueur se trouve sur la case " + m.joueur.casePosition.to_s()
   
   puts "\nAppuyez sur entrer pour continuer\n"
   names = gets
end

puts "\nFin de la partie !"
