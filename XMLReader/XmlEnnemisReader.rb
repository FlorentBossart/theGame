#!/usr/bin/env ruby 

## 
# Fichier        : XmlEnnemisReader.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier XML des ennemis et de les ajouter à la bibliothèque correspondante.
#

require 'Bibliotheque/BibliothequeTypeEnnemi.rb'
require 'Type/TypeEnnemi.rb'
require 'rexml/document'
include REXML

class XmlEnnemisReader
    
    
    ##
    # Méthode statique permettant de récupérer les ennemis et de les ajouter
    #
    def XmlEnnemisReader.lireXml()
        #Ouvre le fichier XML contenant les références 
        begin
            file = File.new("XMLFile/types_ennemis.xml")
            doc = Document.new(file)
            rescue
            puts "Impossible d'ouvrir le fichier XML des ennemis."
        end
        
        #Pour chaque référence du fichier XML...
        doc.elements.each('types_ennemis/type') do |s|
            #... on ajoute à la bibliothèque
            BibliothequeTypeEnnemi.ajouter(s.elements['intitule'].text,
                                           TypeEnnemi.creer(
                                                             s.elements['intitule'].text, 
                                                             s.elements['energieBase'].text.to_i
                                                             ))
        end
    end
    
    
end
