#!/usr/bin/env ruby 

## 
# Fichier        : XmlMangeablesReader.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe permet de parcourir le fichier XML des mangeables et de les ajouter à la bibliothèque correspondante.
#

require 'Bibliotheque/BibliothequeTypeMangeable.rb'
require 'Type/TypeMangeable.rb'
require 'rexml/document'
include REXML

class XmlMangeablesReader
    
    
    ##
    # Méthode statique permettant de récupérer les mangeables et de les ajouter
    #
    def XmlMangeablesReader.lireXml()
        #Ouvre le fichier XML contenant les références 
        begin
            file = File.new("XMLFile/types_mangeables.xml")
            doc = Document.new(file)
            rescue
            puts "Impossible d'ouvrir le fichier XML des mangeables."
        end
        
        #Pour chaque référence du fichier XML...
        doc.elements.each('types_mangeables/type') do |s|
            #... on ajoute à la bibliothèque
            BibliothequeTypeMangeable.ajouter(s.elements['intitule'].text,
                                           TypeMangeable.creer(
                                                            s.elements['intitule'].text, 
                                                            s.elements['energieRendue'].text.to_f,
                                                            s.elements['prix'].text.to_f,
                                                            s.elements['rarete'].text.to_i 
                                                            ))
        end
      return nil
    end
    
    
end
