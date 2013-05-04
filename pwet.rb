#Test GIT par ludo coucou

require 'gtk2'

Gtk.init
window = Gtk::Window.new( Gtk::Window::TOPLEVEL )
window.title=( "Tooltips" )
window.signal_connect( "destroy" ) { Gtk.main_quit }
window.border_width= ( 10 )
hbox = Gtk::HBox.new( false, 0 )

# Create the tooltips object
tooltips = Gtk::Tooltips.new

# Create the first button
button = Gtk::Button.new( "Button 1" )

# Connect the first tip to button 1
tooltips.set_tip( button, "This is button 1", nil )
hbox.pack_start( button, false, false, 0 )

# Do it again
button = Gtk::Button.new( "Button 2" )
tooltips.set_tip( button, "And this, is button 2", nil )
hbox.pack_start( button, false, false, 0 )

window.add( hbox )
window.show_all
Gtk.main