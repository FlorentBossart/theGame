#!/usr/bin/env ruby 

## 
# Fichier            : Jauges.rb 
# Auteur            : L3SPI - Groupe de projet B 
# Fait partie de : TheGame 
# 
# Cette classe représente les jauges du joueur
# 

require 'gtk2'





#voir où est stocké l'expérience max (dans joueur) vue.joueur.experienceMax

class Jauges
  @or #l'or du joueur
  @nbRepos #nombre de repos du joueur
  @energie #nombre d'energie du joueur
  @experience #nomdre d'experience du joueur
  @experienceMax #l'experience max du joueur
  @barExperience #progressBar de l'experience
  @barEnergie #progressBar de l'energie
  @niveau #niveau actuel du joueur

  
  
  def initialize(nbOr,nbRepos,energie,experience,experienceMax,niveau)
    #Gtk.init();
    @or = nbOr;
    @nbRepos = nbRepos;
    @energie = energie;
    @experience = experience;
    @experienceMax = experienceMax;
    @niveau = niveau;
    initInterface();
      
    #Gtk.main();
         
  end
  
  
  def initInterface()
 

    @barExperience = Gtk::ProgressBar.new();

    @barEnergie = Gtk::ProgressBar.new();
   
    
    #on remplit la jauge
    majJaugeExperience(@experience,@experienceMax);
    
    #on remplit la jauge
    majJaugeEnergie(@energie);
   
    @barExperience.show();
    @barEnergie.show();
      
  end
  
  
  #mise a jour de l'or
  def majJaugeOr(quantite)
    @or = quantite;
  end
  
  #mise a jour du nomdre de repos
  def majJaugeNbRepos(nbRepos)
    @nbRepos = nbRepos;
  end
  
  #mise a jour  de l'energie
  def majJaugeEnergie(quantite)
    @energie  = quantite;
    #@barEnergie.set_fraction(@energie/Difficulte.energieMax)
    @barEnergie.fraction = @energie/100.to_f();
    #@barEnergie.set_fraction(@energie/100);
    @barEnergie.set_text("Energie : "+@energie.to_s + " / " + 100.to_s());

  end
  
  #mise a jour de l'experience
  def majJaugeExperience(quantite,experienceMax)
    @experience = quantite;
    @experienceMax = experienceMax;

    @barExperience.fraction = @experience/@experienceMax.to_f();
    #@barExperience.set_fraction(@experience/@experienceMax);
    @barExperience.set_text("Experience : "+@experience.to_s + " / " + @experienceMax.to_s());
    Gtk.main_iteration
  end
  
  def majNiveau(niveau)
    @niveau = niveau;
  end
  
  def getNiveau()
    return @niveau;
  end
  
  #retourne le nombre d'or
  def getJaugeOr()
    return @or
  end
  
  #retourne le nombre de repos
  def getJaugeNbRepos()
    return @nbRepos;
  end
  
  
  #retourne la jauge d'energie
  def getJaugeEnergie()
    return @barEnergie;
  end
  
  #retourne la jauge d'experience
  def getJaugeExperience()
    return @barExperience
  end


  
end

