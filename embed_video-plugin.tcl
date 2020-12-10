# META NAME shotcanvas (shotcanvas-plugin.tcl)
# META DESCRIPTION V02.3 load a png as patch background 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

#    from README file
# 1. Creates a PNG snapshot of canvas (What you see in your pd patch).
# 2. Creates a SVG file that embed the png image you created.
# 3. Automatically loads a png with the same name as the .pd file and places it in your patch as a background.
#

package require Tcl 8.5
package require Tk
package require pdwindow 0.1

puts "- embed_video-plugin ---------"
puts "  pure data (pd) plugin - lazzaro Ciccolella 2020 marrongiallo.github.io"
puts "  README https://github.com/marrongiallo/embed_video"
puts "  V0.1"
puts "-------------------------"

::pdwindow::post "embed_video-plugin V 0.1 - pure data (pd) plugin\n"
::pdwindow::post "lazzaro Ciccolella 2020 marrongiallo.github.io\n"
::pdwindow::post "README https://github.com/marrongiallo/embed_video\n"
::pdwindow::post "-------------------------\n"


namespace eval E_v {
   variable video_folder "$env(HOME)/Pd/video"
   variable mplayer_pipe
   variable line
}


proc get_done {internal_pipe finestra} {
	global done
	if {[eof $internal_pipe]} {
		catch {close $internal_pipe}
		set done 1
		::set_pipe $finestra
		return
   	}
	gets $internal_pipe ::E_v::line
}

proc set_pipe {finestra} {
	set ::E_v::mplayer_pipe [open "|mplayer -wid [scan [winfo id $finestra.c.f] %x] -vf crop=220:480:44:0 -slave test_video.mkv" r+]
	fileevent $::E_v::mplayer_pipe readable [list get_done $::E_v::mplayer_pipe $finestra]
	puts $::E_v::mplayer_pipe pause
	flush $::E_v::mplayer_pipe
}

proc show_player {finestra} {
	if {[file exists $::E_v::video_folder/[file root $::windowname($finestra)].mkv]} {
		frame $finestra.c.f -width 220 -height 480 -bg red
		place $finestra.c.f -x 240 -y 90
		::set_pipe $finestra
	}
}

proc pause_toggle {finestra} {
	#bind $f <Key> [list puts %K]
	bind $finestra <space> {puts $::E_v::mplayer_pipe pause;flush $::E_v::mplayer_pipe}
}

bind PatchWindow <<Loaded>>  {+show_player %W;pause_toggle %W}

