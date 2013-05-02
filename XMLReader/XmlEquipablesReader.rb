#!/usr/bin/env ruby 

## 
# Fichier        : XmlEquipablesReader.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier XML des équipables et de les ajouter à la bibliothèque correspondante.
#

require 'Bibliotheque/BibliothequeTypeEquipable.rb'
require 'Type/TypeEquipable.rb'
require 'rexml/document'
include REXML

class XmlEquipablesReader
    
    
    ##
    # Méthode statique permettant de récupérer les équipables et de les ajouter
    #
    def XmlEquipablesReader.lireXml()
        #Ouvre le fichier XML contenant les références 
        begin
            file = File.new("XMLFile/types_equipables.xml")
            doc = Document.new(file)
            rescue
            puts "Impossible d'ouvrir le fichier XML des équipables."
        end
        
        #Pour chaque référence du fichier XML...
        doc.elements.each('types_equipables/type') do |s|
            #... on ajoute à la bibliothèque
            BibliothequeTypeEquipable.ajouter(s.elements['intitule'].text,
                                           TypeEquipable.creer(
                                                            s.elements['intitule'].text, 
                                                               s.elements['pourcentageProtection'].text.to_f, 
                                                               s.elements['nbTours'].text.to_i, 
                                                               s.elements['prix'].text.to_i, 
                                                               s.elements['sePorteSur'].text.to_i
                                                            
                                                            ))
        end
      return nil
    end
    
    
end
