#!/usr/bin/env ruby 

## 
# Fichier        : XmlMultilingueReader.rb 
# Auteur         : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# 
#

require 'rexml/document'
include REXML

class XmlMultilingueReader
   
   begin
      @@rootObjets=(Document.new(File.new("XMLFile/Multilingue/FR/DicoObjetsJeu.xml"))).root
      @@rootTextes=(Document.new(File.new("XMLFile/Multilingue/FR/textesJeu.xml"))).root
      rescue
      puts "Impossible d'acceder aux Xml multilingues"
   end 
   
   def XmlMultilingueReader.setLangue(idLangue)
     case idLangue
       when "FR"
          dossier="FR"
       when "EN"
          dossier="EN"
       else
          dossier="FR"
     end
     
     begin
        @@rootObjets=(Document.new(File.new("XMLFile/Multilingue/"+dossier+"/DicoObjetsJeu.xml"))).root
        @@rootTextes=(Document.new(File.new("XMLFile/Multilingue/"+dossier+"/textesJeu.xml"))).root
        rescue
        puts "Impossible d'acceder aux Xml multilingues"
     end
   end
    
   def XmlMultilingueReader.lireNom(objet)
       return @@rootObjets.elements["objet[@id='"+objet.getIntitule+"']/nom"].text
   end
   
  def XmlMultilingueReader.lireDeterminant(objet)
       return @@rootObjets.elements["objet[@id='"+objet.getIntitule+"']/determinant"].text
  end
  
  def XmlMultilingueReader.lireDeterminant_Nom(objet)
       return @@rootObjets.elements["objet[@id='"+objet.getIntitule+"']/determinant"].text+@@rootObjets.elements["objet[@id='"+objet.getIntitule+"']/nom"]
  end
  
  def XmlMultilingueReader.lireDeterminant_Nom(id)
       return @@rootTextes.elements["texte[@id='"+id+"']/contenu"].text
  end
    
end
