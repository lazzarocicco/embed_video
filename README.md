![embed_video logo](embed_video_logo.png)

embed_video
===========
puredata plugin
---------------

Embed a video player in a pd PatchWindows. 

Require MPlayer
----------------

MPlayer must be installed in your system.
> mplayer is an open source software available for all major systems, to install it on your computer follow the instructions given on the manufacturer's website [http://www.mplayerhq.hu/](http://www.mplayerhq.hu/)

Install
--------

Install this plugin like all pure data plugins: copy the file embed_video-plugin.tcl to the pd-external folder on your home page.

Instructions for Use
--------------------

- create a mkv video
- give it the same name as your pd patch
- move it to the video folder

Your video must have the same name as the patch (except for the extension). If your patch is called myPatch.pd, the video must be called myPatch.mkv
Put your video in ~/Pd/video. If you don't have that folder you can create it or in any case you can change the place to save the videos for your patches directly in the plugin file (embed_video-plugin.tcl) by setting the variable video_folder.

Probably the video will appear too big to be used together with other objects of the patch, so you can define a visible area of the video and you can define where to position it by setting the crop and pos variables that you find at the beginning of the plugin file (embed_video-plugin.tcl).

The plugin is really not very interactive: you can only start and pause the video. When the video finishes the player is ready to show it again. The play / pause command is imposed by pressing the space bar.

The plugin has only been tested on linux
----------------------------------------

With some minor changes it can run on windows and mac.

Have a good time

Lazzaro


