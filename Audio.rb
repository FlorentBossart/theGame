#!/usr/bin/env ruby

##
# Fichier        : Audio.rb
# Auteur         : L3SPI - Groupe de projet B
# Fait partie de : TheGame
#
# Cette classe représente la gestion du son .wav définie par :
# == Une liste des sons chargés en mémoire
#

require 'sdl'
require 'XMLReader/XmlRefSonsReader.rb'

class Audio
   
   @@listSoundLoad = Hash.new()
   
   private_class_method :new
   
   ##
   # Permet de charger tous les sons en mémoire
   #
   def Audio.load()
      SDL::init(SDL::INIT_AUDIO) # Initialisation de l'audio SDL
      SDL::Mixer.open(22050, SDL::Mixer::DEFAULT_FORMAT, 2, 1024) # Ouverture du Mixer SDL
      XmlRefSonsReader.lireXml(@@listSoundLoad) # Chargement des sons
      return self
   end
   
   ##
   # Permet de jouer un son suivant son intitule
   #
   def Audio.playSound(intitule)
      SDL::Mixer.play_channel(-1, @@listSoundLoad[intitule], 0)
   end
   
   ##
   # Permet de jouer un son en boucle suivant son intitule
   #
   def Audio.playSoundLoop(intitule)
      SDL::Mixer.play_channel(-1, @@listSoundLoad[intitule], -1)
   end
   
   ##
   # Permet d'activer les sons
   #
   def Audio.activeSound()
      SDL::Mixer.set_volume(-1, 128)
   end 
   
   ##
   # Permet de désactiver les sons
   #
   def Audio.mute()
      SDL::Mixer.set_volume(-1, 0)
   end
      
   ##
   # Permet de mettre en pause les sons
   #
   def Audio.pause()
      SDL::Mixer.pause(-1)
   end
   
   ##
   # Permet de reprendre les sons mis en pause
   #
   def Audio.resume()
      SDL::Mixer.resume(-1)
   end
   
   ##
   # Permet d'arreter tous les sons
   #
   def Audio.stop()
      SDL::Mixer.halt(-1)
   end
   
end