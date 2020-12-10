# META NAME embed_video (embed_video-plugin.tcl)
# META DESCRIPTION V0.1 embed a video using MPlayer in slave mode 
# META AUTHOR <Lazzaro Ciccolella> lazzarocicco@gmail.com

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

## dimen
# dim_w (width of the rectangle to show in the patch)
# dim_h (height of the rectangle to show in the patch)
# crop_x (how many pixels we have to cut starting from the left edge of the video)
# crop_y (how many pixels we have to cut starting from the top edge of the video)
set dim_w 220
set dim_h 480
set crop_x 44
set crop_y 0
## placement
# pos_x (distance in pixel from the left edge of the patch)
# pos_y (distance in pixel from the top edge of the patch)
set pos_x 240
set pos_y 90

variable video_folder "$env(HOME)/Pd/video"

   variable mplayer_pipe
   variable line
   variable pid_player
   variable isplayng 0
   variable video_file
}

proc get_done {internal_pipe finestra} {
	global done
	if {[eof $internal_pipe]} {
		catch {close $internal_pipe}
		set done 1
		set ::E_v::isplayng 0
		::set_pipe $finestra
		return
   	}
	gets $internal_pipe ::E_v::line
	set ::E_v::isplayng 1
	if { [regexp -nocase {PAUSE} $::E_v::line] } {
		set ::E_v::isplayng 0
	}
	#puts $::E_v::line
}

proc set_pipe {finestra} {
	set ::E_v::mplayer_pipe [open "|mplayer -wid [scan [winfo id $finestra.c.f] %x] -vf crop=$::E_v::dim_w:$::E_v::dim_h:$::E_v::crop_x:$::E_v::crop_y -slave $::E_v::video_file" r+]
	set ::E_v::pid_player [pid $::E_v::mplayer_pipe]
	fileevent $::E_v::mplayer_pipe readable [list get_done $::E_v::mplayer_pipe $finestra]
	puts $::E_v::mplayer_pipe pause
	flush $::E_v::mplayer_pipe
}

proc show_player {finestra} {
	if {[file exists $::E_v::video_folder/[file root $::windowname($finestra)].mkv]} {
		set ::E_v::video_file $::E_v::video_folder/[file root $::windowname($finestra)].mkv
		frame $finestra.c.f -width $::E_v::dim_w -height $::E_v::dim_h
		place $finestra.c.f -x $::E_v::pos_x -y $::E_v::pos_y
		::set_pipe $finestra
	}
}

proc pause_toggle {finestra} {
	#bind $f <Key> [list puts %K]
	bind $finestra <space> {puts $::E_v::mplayer_pipe pause;flush $::E_v::mplayer_pipe}
}

proc closed_window {} {
	if {$::E_v::isplayng == 1} {
		puts $::E_v::mplayer_pipe pause
		flush $::E_v::mplayer_pipe
		#exec kill $::E_v::pid_player
	}
}
bind PatchWindow <<Loaded>>  {+show_player %W;pause_toggle %W}
bind PatchWindow <Destroy>  {closed_window}

