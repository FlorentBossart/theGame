class AffichageDebug
  @@DebugOn=false
  
  def AffichageDebug.On()
    @@DebugOn=true
    return nil
  end
  
  def AffichageDebug.Off()
    @@DebugOn=false
    return nil
  end
  
  def AffichageDebug.Afficher(message)
    if(@@DebugOn)
      puts "AffichageDebug-next?"
      gets
      puts "Debug: "+message+"\n\t********\n"
    end
    return nil
  end
end