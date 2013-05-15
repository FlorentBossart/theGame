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
   
  @@FR_dicoObjet = Hash.new()
  @@FR_textesJeu = Hash.new()
  @@EN_dicoObjet = Hash.new()
  @@EN_textesJeu = Hash.new()
  
  @@dicoObjetCourant=@@FR_dicoObjet
  @@textesJeuCourant=@@FR_textesJeu
  
  @@LANGUE="FR"
  
  
  def XmlMultilingueReader.lireXmlLangueFR()
        #Ouvre le fichier XML contenant les objets 
        begin
           file = File.new("XMLFile/Multilingue/FR/DicoObjetsJeu.xml")
           doc = Document.new(file)
        rescue
           puts "Impossible d'ouvrir le fichier langue des objets XML FR."
        end
  
        #Pour chaque référence du fichier XML...
        doc.elements.each('objetsJeu/objet') do |s|
           #... on ajoute à la table
           @@FR_dicoObjet[s.elements['id'].text]=[s.elements['determinant'].text,s.elements['nom'].text]
        end
        
        #Ouvre le fichier XML contenant les objets 
        begin
           file = File.new("XMLFile/Multilingue/FR/textesJeu.xml")
           doc = Document.new(file)
        rescue
           puts "Impossible d'ouvrir le fichier langue des textes XML FR."
        end
  
        #Pour chaque référence du fichier XML...
        doc.elements.each('textesJeu/texte') do |s|
           #... on ajoute à la table
           @@FR_textesJeu[s.elements['id'].text]=s.elements['contenu'].text
        end
        return nil       
  end

  def XmlMultilingueReader.lireXmlLangueEN()
        #Ouvre le fichier XML contenant les objets 
        begin
           file = File.new("XMLFile/Multilingue/EN/DicoObjetsJeu.xml")
           doc = Document.new(file)
        rescue
           puts "Impossible d'ouvrir le fichier langue des objets XML EN."
        end
  
        #Pour chaque référence du fichier XML...
        doc.elements.each('objetsJeu/objet') do |s|
           #... on ajoute à la table
           @@EN_dicoObjet[s.elements['id'].text]=[s.elements['determinant'].text,s.elements['nom'].text]
        end
        
        #Ouvre le fichier XML contenant les objets 
        begin
           file = File.new("XMLFile/Multilingue/EN/textesJeu.xml")
           doc = Document.new(file)
        rescue
           puts "Impossible d'ouvrir le fichier langue des textes XML EN."
        end
  
        #Pour chaque référence du fichier XML...
        doc.elements.each('textesJeu/texte') do |s|
           #... on ajoute à la table
           @@EN_textesJeu[s.elements['id'].text]=s.elements['contenu'].text
        end
        return nil       
  end

   def XmlMultilingueReader.lireXml()
     XmlMultilingueReader.lireXmlLangueFR()
     XmlMultilingueReader.lireXmlLangueEN()
   end
   
   
   
   def XmlMultilingueReader.setLangue(idLangue)
     case idLangue
       when "FR"
         @@dicoObjetCourant=@@FR_dicoObjet
         @@textesJeuCourant=@@FR_textesJeu
       when "EN"
         @@dicoObjetCourant=@@EN_dicoObjet
         @@textesJeuCourant=@@EN_textesJeu
       else
         @@dicoObjetCourant=@@FR_dicoObjet
         @@textesJeuCourant=@@FR_textesJeu
     end
   end
    
   def XmlMultilingueReader.lireNom(objet)
       return @@dicoObjetCourant[objet.getIntitule()][1]
   end
   
  def XmlMultilingueReader.lireDeterminant(objet)
    return @@dicoObjetCourant[objet.getIntitule()][0]
  end
  
  def XmlMultilingueReader.lireDeterminant_Nom(objet)
       determinant=@@dicoObjetCourant[objet.getIntitule()][0]
       if(determinant==nil)
         determinant=""
       end
       nom=@@dicoObjetCourant[objet.getIntitule()][1]
       puts objet.getIntitule()
       return determinant+nom
  end
  
  def XmlMultilingueReader.lireTexte(id)
       return @@textesJeuCourant[id]
  end
    
end
