#Test GIT par ludo coucou

require 'gtk2'

class PwetVue
  
  @modele
  @window
  @i
  
  def setM(m)
    @modele=m
  end
  
  def init()
 
    Gtk.init
    @i=0
    @window = Gtk::Window.new( Gtk::Window::TOPLEVEL )
    @window.title=( "Tooltips" )
    @window.signal_connect( "destroy" ) { Gtk.main_quit }
    @window.border_width= ( 10 )
    hbox = Gtk::HBox.new( false, 0 )
    
    # Create the tooltips object
    tooltips = Gtk::Tooltips.new
    
    # Create the first button
    button = Gtk::Button.new( "Button 1" )
    button.signal_connect('button_press_event'){
      @modele.changeVal("YoYoYoYo")
    }
    
    # Connect the first tip to button 1
    tooltips.set_tip( button, "This is button 1", nil )
    hbox.pack_start( button, false, false, 0 )
    
    # Do it again
    button = Gtk::Button.new( "Button 2" )
    tooltips.set_tip( button, "And this, is button 2", nil )
    hbox.pack_start( button, false, false, 0 )
    button.signal_connect('button_press_event'){
      @modele.changeVal("YeYeYeYe")
      @i+=1
      if(@i==10)
        puts null#erreur
      end
    }
        
    @window.add( hbox )
    @window.show_all
    Gtk.main
  end
  
  def actualise()
    @window.title=( @modele.valeur )
  end
 
end

class PwetMod
  @valeur
  @vue
  
  attr_reader :valeur
  
  def setV(v)
    @vue=v
  end
  
  def changeVal(val)
    @valeur=val
    @vue.actualise()
  end
  
end

v=PwetVue.new()
m=PwetMod.new()
v.setM(m)
m.setV(v)
v.init()